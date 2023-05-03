from django.urls import path
from . import PostsController, PostController


urlpatterns = [
    path('<int:plant_id>/', PostsController.Posts.as_view()),
    path('<int:plant_id>/<int:post_id>/', PostController.post_replies),
]

