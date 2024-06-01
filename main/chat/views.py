from rest_framework import generics, permissions
from .models import ChatMessage
from .serializers import ChatMessageSerializer
from django.db.models import Q


class ChatMessageListCreate(generics.ListCreateAPIView):
    serializer_class = ChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return ChatMessage.objects.filter(
            Q(sender=user) & Q(recipient_id=1) | Q(sender_id=1) & Q(recipient=user)
        )

    def perform_create(self, serializer):
        serializer.save(sender=self.request.user)