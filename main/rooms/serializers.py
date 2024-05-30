from rest_framework import serializers
from .models import AccessToRooms, LevelAccess, Rooms


class LevelAccessSerializer(serializers.ModelSerializer):
    class Meta:
        model = LevelAccess
        fields = ['access_level']


class RoomsSerializer(serializers.ModelSerializer):
    access_level = LevelAccessSerializer()

    class Meta:
        model = Rooms
        fields = ['id', 'number_room', 'access_level']


class AccessToRoomsSerializer(serializers.ModelSerializer):
    number_room = serializers.PrimaryKeyRelatedField(queryset=Rooms.objects.all())

    class Meta:
        model = AccessToRooms
        fields = ['id_user', 'number_room', 'startDatetime', 'endDatetime', 'cause', 'result', 'cause_acc_den', 'admin_part', 'time_req']