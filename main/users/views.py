from rest_framework import generics
from rest_framework import permissions
from rest_framework.views import APIView
from .models import CustomUser, Schedule, EntryExit
from .serializers import CustomUserSerializer, ScheduleSerializer, EntryExitSerializer
from rest_framework.response import Response


# Вывод и обновление данных
class CustomUserDetail(generics.RetrieveUpdateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [permissions.IsAuthenticated]


class CurrentUserView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        serializer = CustomUserSerializer(user)
        return Response(serializer.data)


# Вывод данных
class ScheduleDetail(generics.RetrieveAPIView):
    queryset = Schedule.objects.all()
    serializer_class = ScheduleSerializer
    permission_classes = [permissions.IsAuthenticated]


# Отправка и получение данных
class EntryExitListCreate(generics.ListCreateAPIView):
    queryset = EntryExit.objects.all()
    serializer_class = EntryExitSerializer
    permission_classes = [permissions.IsAuthenticated]

