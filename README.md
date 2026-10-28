# taller_2_3

## Por: Nicolas Bernal M.

# Ejecucion:
* ejecutar el proyecto desde vscode con un emulador mobil elegido como device

# Preguntas
1. ¿Para qué sirve pendingSync?
    * Sirve para marcar un dato como solo local, es decir que un no esta en la nube (en este caso fireabse) y que en la proxima sincronizacion se debe tratar de mandar a la nube.
2. ¿Por qué se guarda primero en Drift?
    * Porque de esta forma si hay un problema con firebase y no se puede conectar la informacion no se pierde sino que se queda local esperando a que se peuda sincronizar.  
3. ¿Qué función cumple el Repository?
    * Funciona como una capa intermedia que coordina de donde se saca y a donde va la informacion, en este caso se saca del local y al momento de guardar primero se guarda local y luego se intenta la sincrinizacion.
4. ¿Qué ocurre si Firebase falla?
    * La nota se va a leer local sin problema y la sincronizacion falla por lo que al guardar queda solo local pero no hay interrupciones en el servicio

# Comandos flutter

# 1. Herramientas (una sola vez por máquina)
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli

# 2. Dependencias de Flutter
flutter pub add firebase_core cloud_firestore

# 3. Vincular la app con Firebase
# Caso A: proyecto existente (taller2-3)
flutterfire configure --project=taller2-3
