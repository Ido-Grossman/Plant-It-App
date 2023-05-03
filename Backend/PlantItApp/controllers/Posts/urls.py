from django.urls import path
from . import PostsController


urlpatterns = [
    path('<int:plant_id>/', PostsController.Posts.as_view()),
]

