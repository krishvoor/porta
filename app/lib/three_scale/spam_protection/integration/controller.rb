module ThreeScale::SpamProtection
  module Integration

    module Controller
      private

      def spam_check_save(object, &block)
        block_given? ? yield : object.save if spam_check(object)
      end

      def verify_captcha(object)
        verify_recaptcha(model: object, attribute: :recaptcha)
      end

      def spam_check(object, session_store: ThreeScale::SpamProtection::SessionStore)
        return true if logged_in?

        case level = site_account.settings.spam_protection_level

        when :none
          true
        when :auto
          auto_check(object, session_store)
        when :captcha
          Rails.logger.debug "[SpamProtection][Integration] Captcha mode - verifying captcha"
          verify_captcha(object)
        else
          System::ErrorReporting.report_error "Unknown spam_protection level: #{level}"
        end
      end

      def auto_check(object, session_store)
        stored_session = session_store.new(request.session)
        if object.spam? && stored_session.marked_as_possible_spam?
          stored_session.mark_possible_spam
          Rails.logger.debug "[SpamProtection][Integration] Captcha filled and object is spam - verifying captcha"
          verify_captcha(object)
        else
          Rails.logger.debug "[SpamProtection][Integration] Not Spam"
          true
        end
      end
    end
  end
end
