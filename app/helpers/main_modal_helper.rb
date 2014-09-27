module MainModalHelper

  def link_to_modal(name = nil, options = nil, html_options = nil, &block)
    html_options = html_options || {}
    html_options[:'data-push'] = 'true'
    html_options[:'data-target'] = '#main-modal-body'
    link_to name, options, html_options, &block
  end

end
