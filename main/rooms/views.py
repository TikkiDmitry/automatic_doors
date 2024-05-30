from rest_framework import generics
from rest_framework import permissions
from .models import AccessToRooms, Rooms
from .serializers import AccessToRoomsSerializer, RoomsSerializer


# Отправка данных
class AccessToRoomsCreate(generics.CreateAPIView):
    queryset = AccessToRooms.objects.all()
    serializer_class = AccessToRoomsSerializer
    permission_classes = [permissions.IsAuthenticated]


# Обновление данных
class AccessToRoomsUpdate(generics.RetrieveUpdateAPIView):
    queryset = AccessToRooms.objects.all()
    serializer_class = AccessToRoomsSerializer
    permission_classes = [permissions.IsAuthenticated]


class RoomsList(generics.ListAPIView):
    queryset = Rooms.objects.all()
    serializer_class = RoomsSerializer
    permission_classes = [permissions.IsAuthenticated]
