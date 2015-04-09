class CreateAllCauses < ActiveRecord::Migration
  def change
    create_table :laboral_causas do |t|
    	t.string 	:rit
    	t.string 	:ruc
    	t.date		:fecha
    	t.string	:caratulado
    	t.string	:tribunal    	
    end

    create_table :procesal_causas do |t|
    	t.string	:tribunal
    	t.string	:tipo
    	t.string	:rol_interno
    	t.string	:rol_unico
    	t.string	:identificacion_causa
    	t.string	:estado
    end

    create_table :suprema_causas do |t|    	
    	t.string	:numero_ingreso
    	t.string	:tipo_recurso
    	t.date		:fecha_ingreso
    	t.string	:ubicacion
    	t.date		:fecha_ubicacion
    	t.string	:corte
    	t.string	:caratulado
    end

    create_table :corte_causas do |t|
    	t.string	:numero_ingreso
    	t.date		:fecha_ingreso
    	t.string	:ubicacion
    	t.date		:fecha_ubicacion
    	t.string	:corte
    	t.string	:caratulado
    end

    

  end
end
