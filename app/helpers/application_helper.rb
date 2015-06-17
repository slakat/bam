module ApplicationHelper

  # Helper for reports_form selects
  def select2_helper(id, options, behaviour)
    select_tag id, options, class: 'form-control select select-default w-100pc', data: behaviour, required: true
  end
  # Entrega un popover con el contenido, titulo y placement especificados. Si html es true, permite incrustar HTML en el popover
  def popover_tag(title = '', content = '', placement = 'top', html = false)
    content_tag(
        :div, '', {
                class: 'fa fa-question-circle txt-white pull-right',
                data: {
                    behaviour: 'popover', container:'body', toggle: 'popover', placement: placement,
                    trigger: 'hover', content: content, html: html
                },
                title: title
            }
    )
  end

  def role_inline role, symbol
    best_in_place role, symbol, as: :select, :url => user_causa_path(role), collection: [[1,"ON"],[2,"OFF"]] , "rel"=>"tooltip", "title"=>"ON/OFF"
  end
end
