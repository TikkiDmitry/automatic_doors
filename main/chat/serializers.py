from rest_framework import serializers
from .models import ChatMessage
from users.serializers import CustomUserSerializer
from users.models import CustomUser


class ChatMessageSerializer(serializers.ModelSerializer):
    sender = serializers.PrimaryKeyRelatedField(queryset=CustomUser.objects.all())
    recipient = serializers.PrimaryKeyRelatedField(queryset=CustomUser.objects.all())

    class Meta:
        model = ChatMessage
        fields = ['sender', 'recipient', 'message', 'time']
        extra_kwargs = {
            'time': {'read_only': True},
        }