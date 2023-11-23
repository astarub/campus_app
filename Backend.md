This page keeps all information and steps to install and configure the Appwrite backend.
All commands are for Linux only. If you wish to use another OS, you will have to adapt them to your OS.
--- 

# Basic Concept 

The backend of the Campus App serves as the main management unit for all processes the involve push notifications and data storage. 
As of right now, [Appwrite](https://appwrite.io/) is used as our backend software. 

Upon startup of the app a new user account or session, depending on whether an account already exists, is created.
Each account has a randomized email address serving as the user identifier and a randomized password. 
Both values are random numbers and cannot be traced back to any personal data. 

The following features are currently backed by our backend: 
- Push notifications for saved events. 
  - This is done by saving the Firebase Messaging token and the id of the event in the ``saved_events`` collection under the ``push_notifications`` database.
  - Upon startup the saved events are synchronized across the server and the app, which is done by adding locally saved events to the database and removing events that are no loner saved on the client side.
- Configuration storage
  - Serving dynamic configuration attributes e.g. API URLs, update statuses, etc.

---

## Installation 

System requirements:
- 1 CPU Core and 2GB of RAM
- Docker 
- Docker Dompose Version 2 

Follow the installation guide as instructed here: https://appwrite.io/docs/installation

In order to create the databases you also have to install the Appwrite CLI which can be found here: https://appwrite.io/docs/command-line

# After setup, make sure to follow the Environment Variables section, otherwise you won't be able to communicate with your own backend

---

## Configuration

After you have installed the backend, you have to create your first project with a unique project id.

---

## Databases 

To create the required databases for the campus app, you have to run the following commands:

### Push Notifications 

- Create the database:
  - ``appwrite databases create --databaseId push_notifications --name 'Push Notifications'``

#### Saved Events

1. Create the saved events collection: 
   - ``appwrite databases createCollection --databaseId push_notifications --collectionId saved_events --name 'Saved Events' --permissions 'create("users")' --documentSecurity true``

2. Create the following attributes for the ``saved_events`` collection:
   - String fcmToken : ``appwrite databases createStringAttribute --databaseId push_notifications --collectionId saved_events --key fcmToken --size 250 --required true``
   - int eventId : ``appwrite databases createIntegerAttribute --databaseId push_notifications --collectionId saved_events --key eventId --required true``
   - String startDate : ``appwrite databases createStringAttribute --databaseId push_notifications --collectionId saved_events --key startDate --size 30 --required true``
   
3. Create an index for the ``saved_events`` collection:
   - ``appwrite databases createIndex --databaseId push_notifications --collectionId saved_events --key index --type key --attributes 'fcmToken' --orders 'ASC'``


### Accounts

- Create the ``accounts`` database:
   - ``appwrite databases create --databaseId accounts --name 'Accounts'``

#### Last Login Collection:

1. Create the ``last_login`` collection:
   - ``appwrite databases createCollection --databaseId accounts --collectionId last_login --name 'Last Login' --permissions 'create("users")' --documentSecurity true``

2. Create the following attributes for the ``last_login`` collection:
   - String userId : ``appwrite databases createStringAttribute --databaseId accounts --collectionId last_login --key userId --size 25 --required true``
   - String date : ``appwrite databases createStringAttribute --databaseId accounts --collectionId last_login --key date --size 30 --required true``
   
3. Create an index for the ``last_login`` collection:
   - ``appwrite databases createIndex --databaseId accounts --collectionId last_login --key index --type key --attributes 'userId' --orders 'ASC'``

### Data

- Create the ``data`` database: 
  - ``appwrite databases create --databaseId data --name 'Data'``

#### Publishers

1. Create the ``publishers`` collection:
   - ``appwrite databases createCollection --databaseId data --collectionId publishers --name 'Publishers' --permissions 'read("any")'``

2. Create the following attributes for the ``publishers`` collection:
   - String wpUserId : ``appwrite databases createIntegerAttribute --databaseId data --collectionId publishers --key id --required true``
   - String name : ``appwrite databases createStringAttribute --databaseId data --collectionId publishers --key name --size 100 --required true``
   - String initiallyDisplayed : ``appwrite databases createBooleanAttribute --databaseId data --collectionId publishers --key initiallyDisplayed --xdefault false --required false``
   - bool hidden : ``appwrite databases createBooleanAttribute --databaseId data --collectionId publishers --key hidden --xdefault false --required false``

3. Create an index for the ``publishers`` collection:
   - ``appwrite databases createIndex --databaseId data --collectionId publishers --key index --type key --attributes 'id' --orders 'ASC'``

#### Study courses

1. Create the ``study_courses`` collection:
   - ``appwrite databases createCollection --databaseId data --collectionId study_courses --name 'Studiengänge' --permissions 'read("any")'``

2. Create the following attributes for the ``study_courses`` collection:
   - String wpUserId : ``appwrite databases createIntegerAttribute --databaseId data --collectionId study_courses --key pId --required true``
   - String name : ``appwrite databases createStringAttribute --databaseId data --collectionId study_courses --key name --size 100 --required true``
   - String faculty : ``appwrite databases createStringAttribute --databaseId data --collectionId study_courses --key faculty --size 220 --required true``
   
3. Create an index for the ``study_courses`` collection:
   - ``appwrite databases createIndex --databaseId data --collectionId study_courses --key index --type key --attributes 'pId' --orders 'ASC'``

---

## Cloud Functions

Cloud functions can be written in a variety of programming language such as Python or Javascript. 
We chose JavaScript, powered by NodeJS to run our cloud functions. 

### Saved Event Push Notifications 

1. Create the respective Cloud Function:
   - ``appwrite functions create --functionId push_saved_events --name 'Saved Event Push Notifications' --runtime node-16.0 --execute users``

2. Create an API key and set the ``API_KEY`` secret as a function variable using the Appwrite console webinterface.

3. Create a deployment through the web interface or run the following command (Replace the path with your path to the savedEvents cloud function folder from our [cloud functions](https://github.com/astarub/aw-functions) repository:
   - ``appwrite functions createDeployment --functionId push_saved_events --activate=true --entrypoint="savedEventPushNotification.js"--code aw-functions/push-notifications/savedEventsNotification/``

### Create User

1. Create the respective Cloud Function:
   - ``appwrite functions create --functionId create_user --name 'Create User' --runtime node-16.0 --execute any``

2. Add your Appwrite API key as as a function variable, while using the ``API_KEY`` identifier.

3. Generate a random string and set it as a function variable with the ``AUTH_KEY`` identifier.

4. Create a deployment through the web interface or run the following command: 
   - ``appwrite functions createDeployment --functionId create_user  --activate=true --entrypoint="createUser.js" --code aw-functions/users/createUser/``

### General Push Notifications 

1. Create the respective Cloud Function: 
   - ``appwrite functions create --functionId push_general --name 'General Push Notifications' --runtime node-16.0``

2. Generate a random string and set it as a function variable with the ``AUTH_KEY`` identifier.

3. Create a deployment through the web interface or run the following command:
   - ``appwrite functions createDeployment --functionId push_general --activate=true --entrypoint="sendPushNotification.js" --code aw-functions/push-notifications/generalNotification``

---

Miscellaneous commands: 
- Delete deployment 
  - ``appwrite functions deleteDeployment --deploymentId <Deployment-ID> --functionId <Function-ID>``




