from rest_framework import generics, permissions
from .models import ChatMessage
from .serializers import ChatMessageSerializer


class ChatMessageListCreate(generics.ListCreateAPIView):
    queryset = ChatMessage.objects.all()
    serializer_class = ChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(sender=self.request.user)  # Установка текущего пользователя как отправителя