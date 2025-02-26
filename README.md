# Flujo de Ramas en Git para Configuración de Servidores

Este repositorio contiene scripts, configuraciones y documentación de los servidores del proyecto. Para mantener una estructura organizada, seguimos una estrategia simplificada de Git Flow.

 **Estructura de Ramas en Git**

Para este tipo de repositorio, se recomienda una estrategia más estable sin tantas ramas temporales, ya que los cambios en servidores deben ser bien controlados.

 **Ramas Principales (Persistentes):**

Estas ramas siempre existen y representan los estados clave del código.

* **main (Producción)**
    * ✅ Contiene los scripts y configuraciones estables y probadas.
    * ✅ Solo se actualiza mediante merges desde staging cuando un script ha sido validado.
    * ✅ No se hacen cambios directos en esta rama.

    ```bash
    # Fusionar cambios de staging a main cuando un script está listo
    git checkout main
    git merge staging
    ```

* **staging (Pruebas)**
    * ✅ Contiene scripts en fase de pruebas antes de pasarlos a producción.
    * ✅ Recibe cambios desde feature/*.
    * ✅ Se mantiene funcional y estable para evitar errores en servidores de pruebas.

    ```bash
    # Crear una nueva rama de desarrollo desde staging
    git checkout staging
    ```

 **Ramas Temporales (Se eliminan al finalizar):**

Las siguientes ramas se crean solo cuando hay un cambio importante y se eliminan después.

* **feature/* (Nuevos Scripts o Configuraciones)**
    * Se crean desde staging cuando se desarrolla un nuevo script o configuración.
    * Cuando se termina, se fusiona en staging y se elimina.

    ```bash
    # Crear una nueva rama para un script o configuración nueva
    git checkout staging
    git checkout -b feature/configurar-firewall
    #Después de finalizar el desarrollo y pruebas:
    git checkout staging
    git merge feature/configurar-firewall
    git branch -d feature/configurar-firewall
    ```

* **hotfix/* (Corrección Rápida en Producción)**
    * Se crean desde main para corregir errores críticos en scripts en producción.
    * Se fusionan en main y staging, luego se eliminan.

    ```bash
    # Crear una rama hotfix para corregir un error en un script en producción
    git checkout main
    git checkout -b hotfix/corregir-permisos
    #Después de corregir el problema:
    git checkout main
    git merge hotfix/corregir-permisos
    git checkout staging
    git merge hotfix/corregir-permisos
    git branch -d hotfix/corregir-permisos
    ```
