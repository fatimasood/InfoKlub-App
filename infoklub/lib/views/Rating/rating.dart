import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/rating/rating_viewmodel.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RatingViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.halfwhite,
        appBar: AppBar(
          backgroundColor: AppTheme.halfwhite,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Rating',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: const SafeArea(
          child: RatingScreenLayout(),
        ),
      ),
    );
  }
}

class RatingScreenLayout extends StatelessWidget {
  const RatingScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded makes this part take all available space except what's needed for the button
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: const RatingScreenContent(),
          ),
        ),

        // Button container with padding
        Container(
          padding: const EdgeInsets.all(16.0),
          color: AppTheme.halfwhite, // Match background color
          child: Consumer<RatingViewModel>(
            builder: (context, viewModel, child) {
              return CustomButton(
                color: AppTheme.secondaryColor,
                text: "Send Feedback",
                onPressed: () async {
                  if (viewModel.ratingData.rating > 0) {
                    await viewModel.submitRating();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your feedback!'),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please rate your experience first"),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class RatingScreenContent extends StatelessWidget {
  const RatingScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RatingViewModel>(context);
    final rating = viewModel.ratingData.rating;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'How would you rate your experience?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please share your feedback to help us improve',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Center(
          child: StarRating(
            rating: rating,
            onRatingChanged: (newRating) {
              viewModel.setRating(newRating);
            },
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            rating == 0
                ? 'Tap a star to rate'
                : 'You rated: $rating star${rating > 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Comment',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        TextField(
          style: const TextStyle(color: Colors.black, fontSize: 12),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Tell us more about your experience...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
                width: 2.0,
              ),
            ),
            filled: true,
            fillColor: AppTheme.halfwhite,
          ),
          onChanged: (value) {
            viewModel.setComment(value);
          },
        ),
        // Reduced bottom space since we have the button container
        const SizedBox(height: 10),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 50,
          ),
        );
      }),
    );
  }
}
