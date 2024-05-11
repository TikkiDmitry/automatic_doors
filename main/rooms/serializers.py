from rest_framework import serializers
from .models import AccessToRooms, LevelAccess, Rooms
from users.serializers import CustomUserSerializer


class LevelAccessSerializer(serializers.ModelSerializer):
    class Meta:
        model = LevelAccess
        fields = ['access_level']


class RoomsSerializer(serializers.ModelSerializer):
    access_level = LevelAccessSerializer()

    class Meta:
        model = Rooms
        fields = ['number_room', 'access_level']


class AccessToRoomsSerializer(serializers.ModelSerializer):
    id_user = CustomUserSerializer()
    number_room = RoomsSerializer()

    class Meta:
        model = AccessToRooms
        fields = ['id_user', 'number_room', 'time', 'cause', 'result', 'cause_acc_den', 'admin_part', 'time_req']