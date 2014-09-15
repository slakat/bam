BaseApplication
===============

Creemos aquí la aplicación base :)

# Instalación #

Clonar la aplicación base 

```
git clone https://github.com/HasuSoftware/BaseApplication --origin BaseApplication [MY-NEW-PROJECT] 
```

Crear en GitHub un repositorio con nombre [MY-NEW-PROJECT]

En consola, ejecutar:

```
git remote add origin git@github.com:[MY-GITHUB-ACCOUNT]/[MY-NEW-PROJECT].git
git push -u origin master
```

Ejemplo:

1. ``` git clone https://github.com/HasuSoftware/BaseApplication --origin BaseApplication hasu-timesheet ```
2. Se creo en GitHub a nombre de HasuSoftware el repositorio hasu-timesheet
3. ```git remote add origin https://github.com/HasuSoftware/hasu-timesheet.git```
4. ```git push -u origin master```


## Devise ##

```
rails generate devise:install
```

Más información en <https://github.com/plataformatec/devise>

## Cancancan ##

```
rails g cancan:ability
```

Más información en <https://github.com/CanCanCommunity/cancancan>

