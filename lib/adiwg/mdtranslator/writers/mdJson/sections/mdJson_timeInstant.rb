# mdJson 2.0 writer - time instant

# History:
#   Stan Smith 2017-03-15 original script

require 'jbuilder'
require_relative 'mdJson_identifier'
require_relative 'mdJson_dateTime'

module ADIWG
   module Mdtranslator
      module Writers
         module MdJson

            module TimeInstant

               def self.build(hTimeInstant)

                  Jbuilder.new do |json|
                     json.id hTimeInstant[:timeId]
                     json.description hTimeInstant[:description]
                     json.identifier Identifier.build(hTimeInstant[:identifier]) unless hTimeInstant[:identifier].empty?
                     json.instantName hTimeInstant[:instantNames] unless hTimeInstant[:instantNames].empty?
                     json.dateTime DateTime.build(hTimeInstant[:timeInstant]) unless hTimeInstant[:timeInstant].empty?
                  end

               end # build
            end # TimeInstant

         end
      end
   end
end
