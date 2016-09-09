module EnquiriesHelper

  def progress_bar_percentage(enquiry)
    case enquiry.cached_votes_up
      when 0 then 0
      when 1..Enquiry.votes_needed_for_success then (enquiry.cached_votes_up.to_f * 100 / Enquiry.votes_needed_for_success).floor
      else 100
    end
  end

      def supports_percentage(enquiry)
        percentage = (enquiry.cached_votes_up.to_f * 100 / Enquiry.votes_needed_for_success)
    case percentage
      when 0 then "0%"
      when 0..(0.1) then "0.1%"
      when (0.1)..100 then number_to_percentage(percentage, strip_insignificant_zeros: true, precision: 1)
      else "100%"
    end
  end

        def namespaced_enquiry_path(enquiry, options={})
          @namespace_enquiry_path ||= namespace
          case @namespace_enquiry_path
    when "management"
      management_enquiry_path(enquiry, options)
    else
      enquiry_path(enquiry, options)
    end
  end

end
