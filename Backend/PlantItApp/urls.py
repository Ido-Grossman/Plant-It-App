from django.urls import path, include
from . import views

urlpatterns = [
    path('accounts/', include('PlantItApp.controllers.Accounts.urls')),
    path('users/', include('PlantItApp.controllers.Users.urls')),
    path('plants/', include('PlantItApp.controllers.Plants.urls')),
    path('posts/', include('PlantItApp.controllers.Posts.urls')),
    path('diseases/', include('PlantItApp.controllers.Diseases.urls')),
    path('assistant/', views.assistant)
]
