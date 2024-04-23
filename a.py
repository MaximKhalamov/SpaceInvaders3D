import numpy as np

def angle_between_vectors(vector1, vector2):
    dot_product = np.dot(vector1, vector2)
    magnitude_1 = np.linalg.norm(vector1)
    magnitude_2 = np.linalg.norm(vector2)
    cos_angle = dot_product / (magnitude_1 * magnitude_2)
    angle = np.arccos(cos_angle)
    return angle

def angle_between_vectors_using_atan2(vector1, vector2):
    angle = np.arctan2(np.linalg.norm(np.cross(vector1, vector2)), np.dot(vector1, vector2))
    return angle

# Пример использования
vector1 = np.array([0, 2, 0])
vector2 = np.array([0, -2, 0])

angle_rad = angle_between_vectors(vector1, vector2)
angle_deg = np.degrees(angle_rad)
print("Угол между векторами (в радианах):", angle_rad)
print("Угол между векторами (в градусах):", angle_deg)

angle_rad_atan2 = angle_between_vectors_using_atan2(vector1, vector2)
angle_deg_atan2 = np.degrees(angle_rad_atan2)
print("Угол между векторами через atan2 (в радианах):", angle_rad_atan2)
print("Угол между векторами через atan2 (в градусах):", angle_deg_atan2)
