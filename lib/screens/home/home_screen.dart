import 'package:flutter/material.dart';
import '../../widgets/common/stat_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP SECTION - Date & Calorie Progress
            _buildTopSection(),
            SizedBox(height: 24),
            
            // MIDDLE SECTION - Food Library & Actions
            _buildMiddleSection(context),
            SizedBox(height: 24),
            
            // BOTTOM SECTION - Quick Stats
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Today's Date
          Text(
            'Today - ${DateTime.now().toString().split(' ')[0]}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          
          // Calorie Progress Circle
          Container(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: 0.65, // 65% progress (mock data)
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1,300',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'of 2,000',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'calories',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // Add Food Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to add food screen
                print('Add Food pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Food',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        
        // Search Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search food library...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // Recent Foods & Custom Meal Buttons
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Recent Foods',
                Icons.history,
                Colors.blue,
                () => print('Recent Foods pressed'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Add Custom Meal',
                Icons.add_circle,
                Colors.orange,
                () => print('Add Custom Meal pressed'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 32),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Weekly Average',
                value: '1,850',
                unit: 'calories/day',
                color: Colors.purple,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Yesterday',
                value: '2,100',
                unit: 'calories',
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

} 
