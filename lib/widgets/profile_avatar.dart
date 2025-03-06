import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.size = 32,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Hero(
        tag: 'profile-avatar',
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? Icon(
                  Icons.person_outline,
                  size: size * 0.6,
                  color: Colors.grey[400],
                )
              : null,
        ),
      ),
    );
  }
}

