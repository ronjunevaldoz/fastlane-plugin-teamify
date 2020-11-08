require 'fastlane/action'
require_relative '../helper/teamify_helper'

module Fastlane
  module Actions
    class TeamifyAction < Action
      def self.run(params)
        require 'net/http'
        require 'uri'

        UI.message("The teamify plugin is running!")

        uri = URI.parse(params[:teams_webhook_url]) 
        header = {'Accept': 'application/json'}
        message_card = {
          "@type": "MessageCard",
          "@context": "http://schema.org/extensions",
          "themeColor": params[:theme_color],
          "summary": params[:summary],
          "sections": [{
              "activityTitle": params[:title],
              "activitySubtitle": params[:sub_title],
              "activityImage": params[:image],
              "facts": params[:facts],
              "markdown": true
          }]
        }

        # Create the HTTP objects
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = message_card.to_json

        # Send the request
        response = http.request(request)

        if response.code.to_i == 200 && response.body.to_i == 1
          UI.success "Message card has successfuly sent to teams channel."
        else
          UI.error "An error occurred: #{response.body}"
        end
      end

      def self.description
        "MS Teams message card fastlane plugin"
      end

      def self.authors
        ["Ron June Valdoz"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :teams_webhook_url,
                                  env_name: "TEAMIFY_WEBHOOK_URL",
                               description: "Teams channel webhook link",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :theme_color,
                                  env_name: "TEAMIFY_THEME_COLOR",
                               description: "Message card theme color",
                                  optional: true,
                                      type: String,
                             default_value: "0076D7"),
          FastlaneCore::ConfigItem.new(key: :summary,
                                  env_name: "TEAMIFY_SUMMARY",
                               description: "Message card summary",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :title,
                                  env_name: "TEAMIFY_TITLE",
                                description: "Message card activity title",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :sub_title,
                                  env_name: "TEAMIFY_SUB_TITLE",
                                description: "Message card activity subtitle",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :image,
                                  env_name: "TEAMIFY_IMAGE",
                                description: "Message card activity image",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :facts,
                                  env_name: "TEAMIFY_FACTS",
                                description: "Message card activity facts",
                                  optional: false,
                                      type: Array),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
