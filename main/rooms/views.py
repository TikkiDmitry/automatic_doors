from rest_framework import generics
from rest_framework import permissions
from .models import AccessToRooms
from .serializers import AccessToRoomsSerializer


# Отправка и получение данных
class AccessToRoomsListCreate(generics.ListCreateAPIView):
    queryset = AccessToRooms.objects.all()
    serializer_class = AccessToRoomsSerializer
    permission_classes = [permissions.IsAuthenticated]


# Обновление данных
class AccessToRoomsUpdate(generics.UpdateAPIView):
    queryset = AccessToRooms.objects.all()
    serializer_class = AccessToRoomsSerializer
    permission_classes = [permissions.IsAuthenticated]
