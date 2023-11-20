# Environment Variables

In order to test the backend service you will have to set your own API key, for your very own server, in order to use the ``create_user`` function.

To do that you will have to:
- Create an .env file in the root directory
- Set the value of ``APPWRITE_CREATE_USER_AUTH_KEY`` to your function's api key
- Rebuild the ``env.g.dart`` file in the ``/env/`` folder, using the ``flutter pub run build_runner build`` command
- Re-add all other previous keys e.g. the mensa api key and the firebase key, but make sure to replace the value of ``APPWRITE_CREATE_USER_AUTH_KEY`` with the newly generated output
- Start debugging