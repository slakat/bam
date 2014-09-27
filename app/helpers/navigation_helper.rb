module NavigationHelper

  def active_link_to(name, path, options = {}, html_options = {}, &block)

    if name.is_a?(Hash)
      options = name
      html_options = path
    end

    has_active(options, html_options)

    if block_given?
      link_to name, path, html_options, &block
    else
      link_to name, path, html_options
    end
  end

  # The same as #link_to, but the 3rd param is the active condition, 4rd param is the html_options hash.
  #
  # == Examples:
  #   li_link_to 'Home', root_path, { home: 'index' }
  #   li_link_to 'Home', root_path, { home: %w(index contact) }
  #   li_link_to 'Users', users_path, { users: %w(index show edit) }
  def li_link_to(name, path, options = {}, html_options = {}, &block)

    if name.is_a?(Hash)
      options = name
      html_options = path
    end

    has_active(options, html_options)

    if block_given?
      content_tag(:li, html_options, &block)
    else
      content_tag(:li, link_to(name, path), html_options)
    end
  end

  def li_link_to_fa(name, path, icon, options, html_options = {})
    li_link_to options, html_options do
      link_to fa_icon(icon, text: name), path
    end
  end

  private

  # Adds to #html_options[:class] the 'active' class if the actual
  # controller and action match the #options Hash
  #
  # Examples:
  #   Supposing controller_name = 'home' and action_name = 'index', the following
  #   calls will add the 'active' class to a html_options hash:
  #     has_active { home: 'index' }, html_options
  #     has_active { home: :index }, html_options
  #     has_active { home: ['index', 'contact'] }, html_options
  #     has_active { home: ['index', 'contact'] }, html_options
  #     has_active { home: %w(index contact) }, html_options
  #
  # == Parameters:
  # options::
  #   A hash that contains the rules for the addition of the 'active' class.
  #   Each key of this hash is supposed to be a valid controller name, while
  #   each value of the hash can be either:
  #     - a string
  #     - a symbol
  #     - an array of symbols
  #     - an array of strings
  #     - an array of symbols and strings
  #     - a hash that contains a single key named 'except', where the value is either:
  #       - A string or symbol
  #       - An array of strings or symbols
  #   Example:
  #     options = 'index'
  #     options = :index
  #     options = [:index, :show]
  #     options = ['index', 'show']
  #     options = ['index', :show]
  #     options = { except: 'index' }
  #     options = { except: :index }
  #     options = { except: [:index, :show] }
  #     options = { except: ['index', 'show'] }
  #     options = { except: ['index', :show] }
  #
  # html_options::
  #   A hash that contains the html options



  def has_active(options, html_options)
    parse_options(options)
    controller_name_sym = controller_name.to_sym

    if options.has_key?(controller_name_sym)
      controller_options = options[controller_name_sym]
      if controller_options.is_a?(Hash) and controller_options.has_key?(:except)
        unless controller_options[:except].include?(action_name)
          html_options[:class] ||= ''
          html_options[:class] += ' active'
        end
      else
        if controller_options.include?(action_name) or controller_options.include?('include_all')
          html_options[:class] ||= ''
          html_options[:class] += ' active'
        end
      end
    end
  end

  # Parses each value of options hash to an array of string values.
  #
  # == Parameters:
  # A Hash representing the options, where each key is a controller name and
  # the values are a String, Symbol or Array of Strings or Symbols.
  # Examples:
  #
  #   Using String values:
  #     parse_options { home: 'index', users: 'index' }
  #     => { home: ['index'], users: ['index'] }
  #
  #  Using Hash values
  #     parse_options { home: :index, users: :index }
  #     => { home: ['index'], users: ['index'] }
  #
  #  Using Array of Strings values
  #     parse_options { home: %w(index contact), users: %w(index show) }
  #     => { home: ['index', 'contact'], users: ['index', 'show'] }
  #
  #  Using Array of Symbol values
  #     parse_options { home: [:index, :edit], users: [:index, :show] }
  #     => { home: ['index', 'edit'], users: ['index', 'show'] }
  #
  def parse_options(options)
    options.each do |controller, actions|
      if actions.is_a?(String) or actions.is_a?(Symbol)
        options[controller] = [actions.to_s]
      end
      if actions.is_a?(Array)
        options[controller] = actions.map { |action| action.to_s }
      end
    end
  end

end