# frozen_string_literal: true
module Decidim
  module Meetings
    # This helper include some methods for rendering meetings dynamic maps.
    module MapHelper
      # Serialize a collection of geocoded meetings to be used by the dynamic map component
      #
      # geocoded_meetings - A collection of geocoded meetings
      def meetings_data_for_map(geocoded_meetings)
        geocoded_meetings.map do |meeting|
          meeting.slice(:latitude, :longitude, :address).merge(title: translated_attribute(meeting.title),
                                                               description: translated_attribute(meeting.description),
                                                               startTimeDay: l(meeting.start_time, format: "%d"),
                                                               startTimeMonth: l(meeting.start_time, format: "%B"),
                                                               startTimeYear: l(meeting.start_time, format: "%Y"),
                                                               startTime: "#{meeting.start_time.strftime("%H:%M")} - #{meeting.end_time.strftime("%H:%M")}",
                                                               icon: icon("meetings", width: 40, height: 70, remove_icon_class: true),
                                                               location: translated_attribute(meeting.location),
                                                               locationHints: translated_attribute(meeting.location_hints),
                                                               link: meeting_path(meeting))
        end
      end
    end
  end
end
