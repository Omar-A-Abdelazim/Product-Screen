import 'package:flutter/material.dart';
import 'package:rate/rate.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedSize = 'M';
  double imageScale = 1.0;
  int quantity = 1;
  double rating = 4.0;
  final double basePrice = 89.0; // السعر الأساسي للقطعة الواحدة

  // خريطة لربط الأحجام بمقاييس الصورة
  final Map<String, double> sizeScales = {
    'S': 0.8,
    'L': 1.0,
    'M': 1.2,
    'XL': 1.4,
    '2XL': 1.6,
  };

  void _onSizeSelected(String size) {
    setState(() {
      selectedSize = size;
      imageScale = sizeScales[size] ?? 1.0;
    });
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _onRatingChanged(double newRating) {
    setState(() {
      rating = newRating;
    });
  }

  // حساب السعر الإجمالي
  double get totalPrice => basePrice * quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              size: 24,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الصورة مع أزرار الأحجام
            ProductImageSection(
              selectedSize: selectedSize,
              imageScale: imageScale,
              onSizeSelected: _onSizeSelected,
              sizeScales: sizeScales,
            ),
            const SizedBox(height: 20),
            // قسم معلومات المنتج
            ProductInfoSection(
              rating: rating,
              quantity: quantity,
              totalPrice: totalPrice,
              onIncrementQuantity: _incrementQuantity,
              onDecrementQuantity: _decrementQuantity,
              onRatingChanged: _onRatingChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImageSection extends StatefulWidget {
  final String selectedSize;
  final double imageScale;
  final Function(String) onSizeSelected;
  final Map<String, double> sizeScales;

  const ProductImageSection({
    super.key,
    required this.selectedSize,
    required this.imageScale,
    required this.onSizeSelected,
    required this.sizeScales,
  });

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imageAssets = [
    "assets/shirt1.png",
    "assets/shirt2.png",
    "assets/shirt3.png",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 450,
      child: Row(
        children: [
          // منطقة الصورة
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // عرض الصور
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _imageAssets.length,
                      itemBuilder: (context, index) {
                        return AnimatedScale(
                          scale: widget.imageScale,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              _imageAssets[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // مؤشر الصفحات
                  PageIndicator(
                    itemCount: _imageAssets.length,
                    currentPage: _currentPage,
                  ),
                ],
              ),
            ),
          ),
          // أزرار الأحجام
          Container(
            width: 60,
            margin: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.sizeScales.keys.map((size) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizeButton(
                    size: size,
                    isSelected: widget.selectedSize == size,
                    onTap: () => widget.onSizeSelected(size),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SizeButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const SizeButton({
    super.key,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE53E3E) : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE53E3E) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: Colors.white,
              fontSize: size == '2XL' ? 12 : 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Audiowide', // إضافة خط Audiowide
            ),
          ),
        ),
      ),
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final double rating;
  final int quantity;
  final double totalPrice;
  final VoidCallback onIncrementQuantity;
  final VoidCallback onDecrementQuantity;
  final Function(double) onRatingChanged;

  const ProductInfoSection({
    super.key,
    required this.rating,
    required this.quantity,
    required this.totalPrice,
    required this.onIncrementQuantity,
    required this.onDecrementQuantity,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان المنتج
          const Text(
            'Belgium EURO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Audiowide', // إضافة خط Audiowide
            ),
          ),
          const SizedBox(height: 8),
          // وصف المنتج
          const Text(
            '20/21 Away by Adidas',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'Audiowide', // إضافة خط Audiowide
            ),
          ),
          const SizedBox(height: 20),
          // التقييم والكمية
          Row(
            children: [
              // التقييم بالنجوم
              Rate(
                iconSize: 24,
                color: const Color(0xFFE53E3E),
                allowHalf: true,
                allowClear: false,
                initialValue: rating,
                readOnly: false,
                onChange: onRatingChanged, // تحديث التقييم عند التغيير
              ),
              const SizedBox(width: 10),
              Text(
                rating.toStringAsFixed(1), // عرض التقييم بعلامة عشرية واحدة
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Audiowide', // إضافة خط Audiowide
                ),
              ),
              const Spacer(),
              // أزرار الكمية
              QuantitySelector(
                quantity: quantity,
                onIncrement: onIncrementQuantity,
                onDecrement: onDecrementQuantity,
              ),
            ],
          ),
          const SizedBox(height: 30),
          // تفاصيل المنتج
          const ProductDetails(),
          const SizedBox(height: 30),
          // زر الإضافة للسلة مع السعر المحدث
          AddToCartButton(totalPrice: totalPrice),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 20),
          ),
        ),
        Container(
          width: 50,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Audiowide', // إضافة خط Audiowide
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Audiowide', // إضافة خط Audiowide
          ),
        ),
        const SizedBox(height: 15),
        _buildDetailRow('Material:', 'Polyester'),
        const SizedBox(height: 10),
        _buildDetailRow('Shipping:', 'In 5 to 6 Days'),
        const SizedBox(height: 10),
        _buildDetailRow('Returns:', 'Within 20 Days'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Audiowide', // إضافة خط Audiowide
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'Audiowide', // إضافة خط Audiowide
            ),
          ),
        ),
      ],
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final double totalPrice;

  const AddToCartButton({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFE53E3E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Audiowide', // إضافة خط Audiowide
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 80,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Text(
                '\$${totalPrice.toInt()}', // عرض السعر الإجمالي المحدث
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Audiowide', // إضافة خط Audiowide
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const PageIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return PageIndicatorDot(isActive: index == currentPage);
      }),
    );
  }
}

class PageIndicatorDot extends StatelessWidget {
  final bool isActive;

  const PageIndicatorDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE53E3E) : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
