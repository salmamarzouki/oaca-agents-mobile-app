from django.db import models


class Agent(models.Model):
    """
    Model representing an agent from the Excel files
    """
    matricule = models.CharField(max_length=20, unique=True, help_text="Agent matricule number")
    nom = models.CharField(max_length=100, help_text="Agent last name")
    prenom = models.CharField(max_length=100, blank=True, null=True, help_text="Agent first name")
    nom_complet = models.CharField(max_length=200, blank=True, null=True, help_text="Full name as in Excel")
    full_name = models.CharField(max_length=200, blank=True, null=True, help_text="Full name (alias)")
    affectation = models.CharField(max_length=100, blank=True, null=True, help_text="Agent affectation/assignment")
    fonction_grade = models.CharField(max_length=200, blank=True, null=True, help_text="Fonction ou grade")

    # Champs spécifiques au fichier PPA&GAT&PT
    date_naissance = models.DateField(blank=True, null=True, help_text="Date de naissance")
    age = models.IntegerField(blank=True, null=True, help_text="Age en 2024")

    # Champs spécifiques au fichier Naima 2022
    FORMATION_CHOICES = [
        ('formation_base', 'Formation de base'),
        ('ab_initio', 'Ab initio'),
        ('formation_gestion_equipe', 'Formation gestion d\'équipe'),
        ('formation_formateur', 'Formation des formateurs'),
        ('formation_leadership', 'Formation leadership'),
        ('autre', 'Autre'),
    ]

    formation = models.CharField(
        max_length=200,
        blank=True,
        null=True,
        help_text="Type de formation reçue"
    )
    formation_autre = models.CharField(
        max_length=200,
        blank=True,
        null=True,
        help_text="Autre formation (si 'Autre' sélectionné)"
    )
    periode = models.CharField(max_length=200, blank=True, null=True, help_text="Période de formation")

    # Nouveaux champs professionnels
    date_recrutement = models.DateField(blank=True, null=True, help_text="Date de recrutement")
    fonction_actuelle = models.CharField(max_length=200, blank=True, null=True, help_text="Fonction actuelle")

    # Nouveaux champs demandés
    fonction_technique_actuelle = models.CharField(
        max_length=200,
        blank=True,
        null=True,
        help_text="Fonction technique actuelle"
    )
    date_fonction_technique_actuelle = models.DateField(
        blank=True,
        null=True,
        help_text="Date fonction technique actuelle"
    )

    affectation_unite = models.CharField(max_length=200, blank=True, null=True, help_text="Affectation unité")
    date_affectation_unite = models.DateField(
        blank=True,
        null=True,
        help_text="Date affectation unité"
    )

    date_fonction_actuelle = models.DateField(blank=True, null=True, help_text="Date fonction actuelle")
    fonction_administration = models.CharField(max_length=200, blank=True, null=True, help_text="Fonction d'administration")
    date_fonction_administration = models.DateField(
        blank=True,
        null=True,
        help_text="Date fonction administration"
    )
    anciennete = models.IntegerField(blank=True, null=True, help_text="Ancienneté en années")

    # Métadonnées
    source_file = models.CharField(max_length=200, help_text="Source Excel file name")
    sheet_name = models.CharField(max_length=100, blank=True, null=True, help_text="Nom de la feuille Excel")
    status = models.CharField(max_length=50, blank=True, null=True, help_text="Status (ok, etc.)")

    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['matricule']
        verbose_name = "Agent"
        verbose_name_plural = "Agents"

    def __str__(self):
        if self.nom_complet:
            return f"{self.matricule} - {self.nom_complet}"
        elif self.prenom:
            return f"{self.matricule} - {self.nom} {self.prenom}"
        else:
            return f"{self.matricule} - {self.nom}"

    def get_full_name(self):
        """Return the full name of the agent"""
        if self.nom_complet:
            return self.nom_complet
        elif self.prenom:
            return f"{self.nom} {self.prenom}"
        else:
            return self.nom

    def get_anciennete_years(self):
        """Calculate years of experience based on age and typical career start"""
        if self.age:
            # Assuming career starts around age 25
            return max(0, self.age - 25)
        return 0

    def get_fonction_grade(self):
        """Determine function/grade based on ministry conditions"""
        anciennete = self.get_anciennete_years()

        # Based on Article 8 - Dispositions transitoires
        if anciennete >= 17:
            return "Responsable cellule d'instruction"
        elif anciennete >= 15:
            return "Contrôleur aire de trafic instructeur"
        elif anciennete >= 14:
            return "Superviseur"
        elif anciennete >= 7:
            return "Assistant de Superviseur"
        elif anciennete >= 1:
            return "Contrôleur aire de trafic"
        else:
            return "Contrôleur aire de trafic stagiaire"
