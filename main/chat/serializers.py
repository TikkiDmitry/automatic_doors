from rest_framework import serializers
from .models import ChatMessage
from users.serializers import CustomUserSerializer


class ChatMessageSerializer(serializers.ModelSerializer):
    sender = CustomUserSerializer()
    recipient = CustomUserSerializer()

    class Meta:
        model = ChatMessage
        fields = ['sender', 'recipient', 'message', 'time']