module Lita
  module Handlers
    class Hangout < Handler
      HANGOUT_PREFIX = 'https://plus.google.com/hangouts/_/'

      config :domain, type: String, required: true

      route(/hangout (.+)/i, :hangout, command: true,
                                          help: { 'hangout <topic>' => t('help.hangout_me_topic') })

      def hangout(response)
        suffix = if response.match_data.size == 1
                   response.user.name
                 else
                   response.match_data[1]
                 end
        response.reply <<~EOF
          Google Hangout for "#{suffix}"
          > <#{hangout_url(suffix)}|Join "#{suffix}"> (with authuser <#{hangout_url(suffix)}?authuser=1|1> or <#{hangout_url(suffix)}?authuser=2|2>)
          > <#{hangout_url(suffix,true)}|Present "#{suffix}"> (with authuser <#{hangout_url(suffix,true)}?authuser=1|1> or <#{hangout_url(suffix,true)}?authuser=2|2>)
        EOF

      end

      def hangout_present(response)
        response.reply hangout_url(response.match_data[1], true)
      end

      private

      def hangout_url(suffix, present=false)
        URI.join(HANGOUT_PREFIX, "#{"present/" if present}", "#{config.domain}/", permalink(suffix)).to_s
      end

      def permalink(subject = '')
        subject.to_s.gsub(/[^[:alnum:]]/, ' ').strip.gsub(/\W+/, '-')
      end
    end

    Lita.register_handler(Hangout)
  end
end
