module BootstrapMessageHelper

  ALERT_TYPES = [:error, :danger, :info, :success, :warning] unless const_defined?(:ALERT_TYPES)

  # Reference: https://codeclimate.com/github/seyhunak/twitter-bootstrap-rails/BootstrapFlashHelper
  def bootstrap_flash(options = {})

    unless options.has_key?(:gritter)
      options[:gritter] = true
    end

    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type.to_sym == :notice
      type = :warning if type.to_sym == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        if options[:gritter]
          flash_messages << js(add_modified_gritter(msg, image: type, title: t('gflash.titles')[type])) if msg
        else
          text = content_tag(:div, bootstrap_data_dismiss + msg, bootstrap_message_class(type))
          flash_messages << text if msg
        end
      end
    end
    flash_messages.join("\n").html_safe
  end

  # Este método se encarga de renderear los errores que tenga un objeto ActiveRecord en un cuadro de danger de Bootstrap.
  # Si no tiene errores no renderea nada.
  # @param [ActiveRecord] model_object Objeto que puede contener errores
  # @param [String] title Titulo para mostrar al principio del cuadro Bootstrap
  def bootstrap_model_errors(model_object = nil, title = nil)
    bootstrap_message = ''
    unless model_object.blank? or !model_object.errors.any?
      error_list = []
      unless title.blank?
        error_list << title
      end
      error_list << '<ul>'
      model_object.errors.full_messages.each do |msg|
        error_list << '<li>'+msg+'</li>'
      end
      error_list << '</ul>'
      error_list_str = error_list.join("\n").html_safe
      bootstrap_message = content_tag(:div, bootstrap_data_dismiss + error_list_str.html_safe, bootstrap_message_class('danger'))
    end
    bootstrap_message.html_safe
  end

  # Este método se es una ayuda para renderear un mesaje personalizado en un cuadro de Bootstrap.
  # @param [Symbol] type tipo de cuadro Bootstrap (:danger, :success, :info, :warning)
  # @param [String] message Mensaje a renderear en el cuadro
  def bootstrap_custom_message(type = nil, message = nil, options = {})

    if type.blank? or message.blank?
      return ''
    elsif !ALERT_TYPES.include?(type)
      return ''
    end

    unless options.has_key?(:gritter)
      options[:gritter] = true
    end

    if options[:gritter]
      bootstrap_custom_msg = js(add_modified_gritter(message.html_safe))
    else
      bootstrap_custom_msg = content_tag(:div, bootstrap_data_dismiss + message.html_safe, bootstrap_message_class(type))
    end

    bootstrap_custom_msg.html_safe
  end

  def bootstrap_data_dismiss
    content_tag(:a, raw('&times;'), :class => 'close', 'data-dismiss' => 'alert')
  end

  def bootstrap_message_class(type)
    { :class => "alert fade in alert-#{type}" }
  end

end