from django.conf import settings
from django.contrib.auth import get_user_model
from google.cloud import dialogflow_v2 as dialogflow
from google.api_core.exceptions import InvalidArgument
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes
from rest_framework.response import Response
from PlantItApp.models import Plant
from .controllers.Users import RecommendationController


def getPlantDetails(plant_name):
    try:
        # Get the plant from the database.
        plant = Plant.objects.get(latin=plant_name)
        # Create a list of strings to be returned to the user.
        ans = [f"Sure! Here are some details about {plant_name} ", f"it is part of the {plant.family} family.",
               f" It is a {plant.category} plant and It is recommended to {plant.watering}",
               f" And prefers {plant.idealight}.", f" It prefers {plant.climate} climate "
               f"where the temperature is between {plant.mincelsius} to {plant.maxcelsius} degrees celsius."]
        return ''.join(ans)
    except Plant.DoesNotExist:
        # If the plant doesn't exist, return an error message.
        return "I'm sorry, but I couldn't find any information about that plant."


def getWateringSchedule(plant_name, user):
    try:
        # Get the plant from the database.
        plant = Plant.objects.get(latin=plant_name)
        # Create a list of strings to be returned to the user.
        ans = [f"You need to water {plant_name} ", f"every {plant.water_duration} days."]
        user_plant = user.user_plants.filter(plant_id=plant.id).first()
        if user_plant:
            ans.append(f" You last watered {plant_name} on {user_plant.last_watering}.")
        return ''.join(ans)
    except Plant.DoesNotExist:
        # If the plant doesn't exist, return an error message.
        return "I'm sorry, but I couldn't find any information about that plant."


def get_plant_recommendations(user):
    recommendation = RecommendationController.recommendations(user)
    size = len(recommendation)
    ans = [f"Here are some plants that you might like: \n"]

    for i in range(size):
        plant = Plant.objects.get(id=recommendation[i])
        common_names = plant.common.all()
        common_names = [name.common for name in common_names]
        common_names = ', '.join(common_names)
        ans.append(f"{i + 1}. {common_names}.\n")
    return ''.join(ans)


@api_view(['POST'])
@authentication_classes([TokenAuthentication])
def assistant(request):
    if not request.user.is_authenticated:
        return Response({"answer": "You must be logged in to use this feature."}, status=status.HTTP_401_UNAUTHORIZED)
    # Get the text from the request and send it to Dialogflow.
    text_to_be_analyzed = request.data.get('message')
    if not text_to_be_analyzed:
        return Response({"answer": "You must send a message to the bot."}, status=status.HTTP_400_BAD_REQUEST)
    session_client = dialogflow.SessionsClient()
    authentication = TokenAuthentication()
    user, token = authentication.authenticate(request)
    session = session_client.session_path(settings.GS_PROJECT_ID, token)

    text_input = dialogflow.types.TextInput(text=text_to_be_analyzed, language_code=settings.DIALOGFLOW_LANGUAGE_CODE)
    query_input = dialogflow.types.QueryInput(text=text_input)

    try:
        response = session_client.detect_intent(session=session, query_input=query_input)
    except InvalidArgument:
        raise
    intent = response.query_result.intent.display_name
    answer = None
    user = get_user_model().objects.get(email=user.email)
    try:
        plant_name = response.query_result.parameters['plant']
        if intent == 'GetPlantDetails':
            answer = getPlantDetails(plant_name)
        elif intent == 'GetWateringSchedule':
            answer = getWateringSchedule(plant_name, user)
    except:
        if intent == 'GetPlantRecommendations':
            answer = get_plant_recommendations(user)
        elif intent == 'GetPlantRecommendations - custom':
            number = int(response.query_result.parameters['number'])
            recommendation = RecommendationController.recommendations(user)
            plant = Plant.objects.get(id=recommendation[number])
            answer = getPlantDetails(plant.latin)
        else:
            answer = response.query_result.fulfillment_text
    return Response({"answer": answer})
