require 'fastlane/action'
require_relative '../helper/plural_converter_helper'

module Fastlane
  module Actions
    class PluralConverterAction < Action
      def self.run(params)
        if params[:plist_path] && params[:xml_path]
          plist_path = params[:plist_path]
          xml_path = params[:xml_path]

          if File.exist?(xml_path)
            # Create and open empty file.
            File.write(plist_path, '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict></dict></plist>')
            plist = Xcodeproj::Plist.read_from_path(plist_path)

            # Read XML and populate PLIST hash.
            xml = File.open(xml_path)
            doc = REXML::Document.new(xml)
            doc.elements.each('resources/plurals') do |plural|
              key = plural.attributes['name']

              format_key = key + '_value'
              dict = { 'NSStringLocalizedFormatKey' => "%#\@#{format_key}@" }
              items_dict = { 'NSStringFormatSpecTypeKey' => 'NSStringPluralRuleType', 'NSStringFormatValueTypeKey' => 'd' }

              plural.elements.each('item') do |item|
                quantity_key = item.attributes['quantity']
                items_dict[quantity_key] = item.text
              end

              dict[format_key] = items_dict
              plist[key] = dict
            end

            # Write changes to PLIST file
            Xcodeproj::Plist.write_to_path(plist, plist_path)

            UI.success("Updated #{params[:plist_path]} 💾.")
            File.read(plist_path)

          else
            UI.user_error!("Couldn't find xml file at path '#{xml_path}'")
          end

        elsif params[:xml_path].nil?
          UI.user_error!("You must specify an xml path")
        elsif params[:plist_path].nil?
          UI.user_error!("You must specify a plist path")
        end
      end

      def self.description
        "Convert Android plural XML resource file to iOS stringsdict file."
      end

      def self.authors
        ["Benoit Deldicque"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :plist_path,
                                  env_name: "PLURAL_CONVERTER_PLIST_PATH",
                               description: "File path for the new Plist file",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :xml_path,
                                  env_name: "PLURAL_CONVERTER_XML_PATH",
                               description: "File path for the Android XML source file",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
