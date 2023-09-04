<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Doctrine\Persistence\ManagerRegistry;
use App\Entity\User;
use Symfony\Component\Serializer\Normalizer\NormalizerInterface;

class UserController extends AbstractController
{
    public function __construct(private ManagerRegistry $doctrine)
    {
    }
    #[Route('/register', name: 'app_register', methods: ['POST'])]
    public function register(Request $request, UserPasswordHasherInterface $passwordHasher, NormalizerInterface $decorated)
    {
        // Obtén los datos JSON enviados en la solicitud
        $requestData = json_decode($request->getContent(), true);
        // Crea un nuevo objeto User
        $user = new User();
        $user->setNombre($requestData['nombre']);
        $user->setApellidos($requestData['apellidos']);
        $user->setRoles(["ROLE_USER"]);
        $user->setEmail($requestData['email']); // Ajusta el nombre de usuario según tu entidad User

        // Codifica la contraseña del usuario
        $hashedPassword = $passwordHasher->hashPassword($user, $requestData['password']); // Ajusta el nombre del campo de contraseña
        $user->setPassword($hashedPassword);

        // Guarda al usuario en la base de datos
        $entityManager = $this->doctrine->getManager();
        $entityManager->persist($user);
        $entityManager->flush();
        // Devuelve una respuesta JSON exitosa
        return new JsonResponse(['user' => $decorated->normalize($user, null, ['groups' => 'register:read']), 'message' => 'Usuario registrado con éxito'], JsonResponse::HTTP_CREATED);
    }
    #[Route('/api/getUserAuth', name: 'app_user_auth', methods: ['POST'])]
    public function getUserAuth(Request $request, NormalizerInterface $decorated)
    {
        if (!$this->isGranted('ROLE_USER')) return new JsonResponse("Necesitas estar autenticado", JsonResponse::HTTP_BAD_REQUEST);
        // Obtén los datos JSON enviados en la solicitud
        $requestData = json_decode($request->getContent(), true);
        $entityManager = $this->doctrine->getManager();
        $user = $entityManager->getRepository(User::class)->findOneBy(['email' => $requestData['email']]);
        return new JsonResponse(['user' => $decorated->normalize($user, null, ['groups' => 'register:read']), 'message' => 'Usuario autenticado con éxito'], JsonResponse::HTTP_CREATED);
    }
    #[Route('/logout', name: 'app_logout')]
    public function logout()
    {
        return new JsonResponse(['message' => 'Sesion cerrada con éxito'], JsonResponse::HTTP_CREATED);
    }
}
