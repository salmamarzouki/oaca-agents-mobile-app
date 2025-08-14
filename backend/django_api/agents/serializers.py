from rest_framework import serializers
from .models import Agent


class AgentSerializer(serializers.ModelSerializer):
    """
    Serializer for Agent model
    """
    full_name = serializers.CharField(source='get_full_name', read_only=True)
    anciennete = serializers.IntegerField(source='get_anciennete_years', read_only=True)
    fonction_grade = serializers.CharField(source='get_fonction_grade', read_only=True)

    class Meta:
        model = Agent
        fields = [
            'id',
            'matricule',
            'nom',
            'prenom',
            'nom_complet',
            'full_name',
            'date_naissance',
            'age',
            'affectation',
            'formation',
            'formation_autre',
            'periode',
            'fonction_technique_actuelle',
            'date_fonction_technique_actuelle',
            'affectation_unite',
            'date_affectation_unite',
            'fonction_administration',
            'date_fonction_administration',
            'status',
            'anciennete',
            'fonction_grade',
            'source_file',
            'sheet_name',
            'created_at',
            'updated_at'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at', 'full_name', 'anciennete', 'fonction_grade']


class AgentListSerializer(serializers.ModelSerializer):
    """
    Simplified serializer for agent list view
    """
    full_name = serializers.CharField(source='get_full_name', read_only=True)
    anciennete = serializers.IntegerField(source='get_anciennete_years', read_only=True)
    fonction_grade = serializers.CharField(source='get_fonction_grade', read_only=True)

    class Meta:
        model = Agent
        fields = [
            'id',
            'matricule',
            'nom',
            'prenom',
            'nom_complet',
            'full_name',
            'date_naissance',
            'age',
            'affectation',
            'formation',
            'formation_autre',
            'periode',
            'fonction_technique_actuelle',
            'date_fonction_technique_actuelle',
            'affectation_unite',
            'date_affectation_unite',
            'fonction_administration',
            'date_fonction_administration',
            'status',
            'anciennete',
            'fonction_grade',
            'source_file',
            'sheet_name'
        ]
