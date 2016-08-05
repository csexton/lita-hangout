module Lita
  module Handlers
    class Hangout < Handler
      HANGOUT_PREFIX = 'https://plus.google.com/hangouts/_/'

      config :domain, type: String, required: true

      route(/hangout$/i, :hangout, command: true, help: { 'hangout' => t('help.hangout') })
      route(/hangout join (.+)/i, :hangout_me, command: true,
                                             help: { 'hangout join <topic>' => t('help.hangout_me_topic') })
      route(/hangout present (.+)/i, :hangout_present, command: true,
                                             help: { 'hangout present <topic>' => t('help.hangout_present_topic') })

      def hangout(response)
        response.reply hangout_url(Time.now.to_i)
      end

      def hangout_me(response)
        if response.match_data.size == 1
          response.reply hangout_url(response.user.name)
        else
          response.reply hangout_url(response.match_data[1])
        end
      end

      def hangout_present(response)
        response.reply hangout_url(response.match_data[1], true)
      end

      private

      def hangout_url(sufix, present=false)
        URI.join(HANGOUT_PREFIX, "#{"present/" if present}", "#{config.domain}/", permalink(sufix)).to_s
      end

      def permalink(subject = '')
        subject.to_s.gsub(/[^[:alnum:]]/, ' ').strip.gsub(/\W+/, '-')
      end
    end

    Lita.register_handler(Hangout)
  end
end
