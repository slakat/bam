module GritterModificationHelper

  def add_modified_gritter(text, *args)
    options = args.extract_options!
    options[:title] = 'Notification' if options[:title].blank?
    options[:image] = asset_path("#{options[:image]}#{options[:image].to_s == 'progress' ? '.gif' : '.png'}") if %w(success warning error notice progress).include?(options[:image].to_s)
    notification = Array.new
    notification.push('onInit(function(){') if options[:nodom_wrap].blank?
    notification.push('jQuery.gritter.add({')
    notification.push("image:'#{options[:image]}',") if options[:image].present?
    notification.push("sticky:#{options[:sticky]},") if options[:sticky].present?
    notification.push("time:#{options[:time]},") if options[:time].present?
    notification.push("class_name:'#{options[:class_name]}',") if options[:class_name].present?
    notification.push("before_open:function(e){#{options[:before_open]}},") if options[:before_open].present?
    notification.push("after_open:function(e){#{options[:after_open]}},") if options[:after_open].present?
    notification.push("before_close:function(e){#{options[:before_close]}},") if options[:before_close].present?
    notification.push("after_close:function(e){#{options[:after_close]}},") if options[:after_close].present?
    notification.push("title:'#{escape_javascript(options[:title])}',")
    notification.push("text:'#{escape_javascript(text)}'")
    notification.push('});')
    notification.push('});') if options[:nodom_wrap].blank?
    text.present? ? notification.join.html_safe : nil
  end

end
