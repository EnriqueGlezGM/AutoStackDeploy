# AutoStackDeploy
Despliegue automático de una aplicación escalable sobre una nube OpenStack utilizando los servicios de orquestación de Terraform

## Como utilizar un repositorio privado

En los reposistorios privados se necesita verificar la identidad. Solo es necesario hacerlo una única vez en el equipo que se quiera usar.
La guia oficial para [generar una nueva clave SSH](https://docs.github.com/es/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) y [agregar una clave SSH y usarla para la autenticación](https://docs.github.com/es/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account).

Despues de tener las claves SSH configuradas, ejecutar el siguiente comando en el escritorio donde se quiera clonar:

```bash
git clone git@github.com:EnriqueGlezGM/AutoStackDeploy.git $HOME/Desktop
```

## Arranque del escenario

```bash
cd $HOME/Desktop/AutoStackDeploy
./1.sh
./2.sh
```

## Destruir del escenario
```bash
cd $HOME/Desktop/AutoStackDeploy
./destroy.sh
```