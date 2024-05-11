from django.urls import path
from .views import ChatMessageListCreate

urlpatterns = [
    path('chat-messages/', ChatMessageListCreate.as_view(), name='chat-message-list-create'),
]