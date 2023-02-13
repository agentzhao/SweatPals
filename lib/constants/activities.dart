class Activity {
  final int id;
  final String name;

  Activity({
    required this.id,
    required this.name,
  });
}

final List<Activity> activities = [
  Activity(id: 1, name: 'Hiking'),
  Activity(id: 2, name: 'Cycling'),
  Activity(id: 3, name: 'Running'),
  Activity(id: 4, name: 'Swimming'),
  Activity(id: 5, name: 'Gymming'),
  Activity(id: 6, name: 'Calisthenics'),
  Activity(id: 7, name: 'Soccer'),
  Activity(id: 8, name: 'Basketball'),
  Activity(id: 9, name: 'Tennis'),
  Activity(id: 10, name: 'Volleyball'),
  Activity(id: 11, name: 'Badminton'),
  Activity(id: 12, name: 'Table Tennis'),
  Activity(id: 13, name: 'Dancing'),
  Activity(id: 14, name: 'Yoga'),
  Activity(id: 15, name: 'Pilates'),
  Activity(id: 16, name: 'Mountain Biking'),
  Activity(id: 17, name: 'Skating'),
  Activity(id: 18, name: 'Trail Running'),
  Activity(id: 19, name: 'Rock Climbing'),
  Activity(id: 20, name: 'Golf'),
];

List<String> intToString(List<dynamic> ids) {
  List<String> names = [];
  for (int id in ids) {
    names.add(activities[id - 1].name);
  }
  return names;
}

List<int> activityToIds(List<Activity> activities) {
  List<int> ids = [];
  for (Activity activity in activities) {
    ids.add(activity.id);
  }
  return ids;
}

List<Activity> idsToActivity(List<dynamic> ids) {
  List<Activity> ans = [];
  for (int id in ids) {
    ans.add(activities[id - 1]);
  }
  return ans;
}

void printActivities(List<Activity> activities) {
  for (Activity activity in activities) {
    print(activity.name);
  }
}
