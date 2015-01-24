module Searchable
  extend ActiveSupport::Concern

  included do
  end

  def an_instance_method
  end

  module ClassMethods

    # SOBREESCRIBIR el método para definir las columnas por las cuales se buscará por defecto
    # Acordarse que debe ser método de clase
    # Ejemplo: [:first_name, :email, enterprise: [:name]]
    def default_searchable_columns
    end

    # Método de búsqueda sobre la tabla del modelo
    # Opciones:
    #   column_names:
    #     Arreglo de columnas a buscar con soporte de tablas asociadas. Si no se especifica se ocupan las columnas por defecto
    #     Ejemplo: [:first_name, :email, enterprise: [:name]]
    def search_strings(search, options={})
      results = self.all
      if search
        #Dividimos el string recibido para buscar por cada término ingresado.
        words = search.strip.split
        #Iteramos por cada término
        words.each do |word|
          results = results.search_by_word(word, options)
        end
      end
      results
    end

    # Métodos de búsqueda
    #TODO Mejoras faltantes: cuando las columnas son [enterprise: :name]
    def search_by_word(search, options={})
      if search
        nested_names = []

        # Si no se definen columnas a buscar se toman las columnas por defecto
        column_names = default_searchable_columns
        if options[:column_names]
          column_names = options[:column_names]
        end

        # Agregamos la sentencia de joins para agregar las tablas asociadas
        base_statement = add_joins_base_statements(column_names)

        # Obtenemos el nombre de la columna de los atributos pedidos
        column_names.each{ |column| nested_names.push(*parse_attr_to_column_name(column))}

        # Le agregamos la sentencia de like a los elementos del arreglo
        nested_names = add_like_statement(nested_names)

        # Juntamos las sentencias con OR
        sql_template = nested_names.join(' OR ')

        # Creamos el arreglo de parámetros para el where
        where_params = [sql_template]

        # Por cada sentencia agregamos el parámetro a buscar (para seguir la norma de la sentencia de where)
        nested_names.length.times{where_params.push("%#{search}%")}

        # Realizamos la consulta
        base_statement = base_statement.where(where_params)

        # Agregamos el group para que no se repitan por el join de tablas
        base_statement.group("#{self.table_name}.id")
      end
    end

    private

    # Obtiene el nombre de la columna a ser consultada junto con el nombre de la tabla a la que pertenece
    def parse_attr_to_column_name(attr)

      if attr.class == Symbol
        # Si el atributo es un símbolo, le asignamos la tabla de la clase actual
        "#{self.table_name}.#{attr.to_s}"
      elsif attr.class == Hash
        # Si es un hash, por cada llave que corresponde a una asociación se le agrega el nombre de la tabla a cada una de
        # sus columnas a buscar
        nested_names = []
        attr.each do |key, value|
          associated_class = self.reflect_on_association(key)
          if associated_class and value
            value.each do |nested_column_name|
              nested_names.push("#{associated_class.table_name}.#{nested_column_name.to_s}")
            end
          end
        end
        nested_names
      end
    end

    # Por cada hash que este entre los nombres de las columnas se le agrega un join a la sentencia
    def add_joins_base_statements(column_names)
      base_statement = self
      column_names.each do |column|
        if column.class == Hash
          column.each do |key, value|
            associated_class = self.reflect_on_association(key)
            if associated_class and value
              base_statement = base_statement.joins(key)
            end
          end
        end
      end
      base_statement
    end

    # Se le da formato de búsqueda a cada elemento
    def add_like_statement(array)
      array.map{ |text| "#{text} LIKE ?"}
    end
  end
end