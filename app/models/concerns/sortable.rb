module Sortable
  extend ActiveSupport::Concern

  included do
  end

  def an_instance_method
  end

  module ClassMethods

    # Deben agregar attr_name para buscar el nombre de la columna en una clase atributo de la clase base
    def has_column_name?(column_name, options ={})
      if options[:attr_name].nil?
        self.column_names.include?(column_name)
      else
        asso = self.reflect_on_association(options[:attr_name])
        if asso
          asso.klass.column_names.include?(column_name)
        else
          false
        end
        # self.reflect_on_all_associations(:belongs_to).each do |asso|
        #   puts asso.klass.column_names.include?(column_name)
        # end
      end
    end

    # Ordena los resultados según el nombre de la columna, dando la opción de ordenar por columnas de alguna clase
    # asociada
    # attr_name: símbolo del atributo asociado a buscar. Ejemplo: :enterprise
    # direction: asc o desc
    #
    def advanced_order(column_name, options={})
      if options[:attr_name].nil?
        if options[:direction].nil?
          self.order(column_name)
        else
          self.order("#{column_name} #{options[:direction]}")
        end
      else
        klass_pluralize = self.reflect_on_association(options[:attr_name]).plural_name
        if options[:direction].nil?
          self.joins(options[:attr_name]).order("#{klass_pluralize}.#{column_name}")
        else
          self.joins(options[:attr_name]).order("#{klass_pluralize}.#{column_name} #{options[:direction]}")
        end
      end
    end
  end
end