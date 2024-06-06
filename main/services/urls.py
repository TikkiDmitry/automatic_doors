from django.urls import path
from .views import BiometricsCaptureView, BiometricAccessView

urlpatterns = [
    # другие пути
    path('biometric-capture/', BiometricsCaptureView.as_view(), name='biometric-capture'),
    path('biometric-access/', BiometricAccessView.as_view(), name='biometric-access'),
]