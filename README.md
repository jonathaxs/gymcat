![Status](https://img.shields.io/badge/Status-Work_In_Progress-yellow?style=for-the-badge)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0C7CFF?style=for-the-badge&logo=swift&logoColor=white)

<img align="left" src="git/appicons/GymCatLightIconRounded.png" width="100">
<img src="git/appicons/GymCatNightIconRounded.png" width="100">

# GymCat

### *A fitness goals app with gamification and motivational cats.*

**GymCat** is an iOS app built with **SwiftUI** that helps users stay consistent with their fitness routine.  
Complete your daily goals, earn a **Cat of the Day**, collect **points**, and unlock **weekly and monthly achievements**.

---

## ⭐ Features

### 🎯 Default Daily Goals
Track 5 metrics:
- Sleep  
- Water  
- Protein  
- Carbohydrates  
- Fats  

Daily progress = **average** of all 5 goals.

---

## 🐾 Cat of the Day & Points (on development)

| Progress | Emoji | Cat | Points |
|----------|-------|------|--------|
| <50% | 😿 | Sad Cat | 15 pts |
| <70% | 😺 | Beginner Cat | 55 pts |
| <90% | 🐈‍⬛ | Fitness Cat | 75 pts |
| ≥90% | 🦁 | Strong Cat | 105 pts |

**Finish Day** → saves the day's record and adds points to the total score.

---

## 📱 Screens (on development)

### TodayView  
- Daily goals with + and – buttons  
- Cat of the Day preview  
- Finish Day button

### AchievementsView  
- Total score display  
- Calendar with cat emojis for each day  
- History list below the calendar  

### SettingsView  
- Edit daily goals  
- Edit personal data
- Enable Apple Health sync
- Enable iCloud Sync

### WelcomeView  
- First-time onboarding  
- User registration  
- Automatic goal calculation  
- Option to manually adjust all values

---

## 🚀 Tech Stack
- Swift + SwiftUI  
- SwiftData  
- @AppStorage  
- Lightweight MVVM structure 