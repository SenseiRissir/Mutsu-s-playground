/**
 * SENSEI'S FITNESS TRACKER
 * Built by MUTSU with bratty love~♡
 * 
 * Features:
 * - BMI, TDEE, BMR calculations
 * - Macro distribution
 * - Ab-focused workout plans
 * - Progress tracking with localStorage
 */

// ==========================================
// CONSTANTS & CONFIG
// ==========================================

const STORAGE_KEY = 'sensei_fitness_data';
const PROGRESS_KEY = 'sensei_fitness_progress';

// Workout database - Ab-focused for tall, broad-shouldered body type
const WORKOUTS = {
    day1: {
        title: "Day 1: Push + Core Annihilation",
        focus: "Chest, Shoulders, Triceps + Abs",
        exercises: [
            { icon: "🏋️", name: "Barbell Bench Press", sets: "4", reps: "8-10", focus: "Chest" },
            { icon: "💪", name: "Overhead Press", sets: "4", reps: "8-10", focus: "Shoulders" },
            { icon: "🔥", name: "Incline Dumbbell Press", sets: "3", reps: "10-12", focus: "Upper Chest" },
            { icon: "💫", name: "Tricep Dips", sets: "3", reps: "12-15", focus: "Triceps" },
            { icon: "🎯", name: "Hanging Leg Raises", sets: "4", reps: "15-20", focus: "Lower Abs" },
            { icon: "⚡", name: "Cable Crunches", sets: "4", reps: "15-20", focus: "Upper Abs" },
            { icon: "🔮", name: "Ab Wheel Rollouts", sets: "3", reps: "10-12", focus: "Full Core" }
        ]
    },
    day2: {
        title: "Day 2: Pull + Core Destruction",
        focus: "Back, Biceps + Abs",
        exercises: [
            { icon: "🏋️", name: "Deadlifts", sets: "4", reps: "5-6", focus: "Full Back" },
            { icon: "💪", name: "Weighted Pull-ups", sets: "4", reps: "8-10", focus: "Lats" },
            { icon: "🔥", name: "Barbell Rows", sets: "4", reps: "8-10", focus: "Mid Back" },
            { icon: "💫", name: "Face Pulls", sets: "3", reps: "15-20", focus: "Rear Delts" },
            { icon: "🎯", name: "Dragon Flags", sets: "3", reps: "8-10", focus: "Full Abs" },
            { icon: "⚡", name: "Pallof Press", sets: "3", reps: "12/side", focus: "Obliques" },
            { icon: "🔮", name: "Dead Bug", sets: "3", reps: "10/side", focus: "Core Stability" }
        ]
    },
    day3: {
        title: "Day 3: Legs + Core Obliteration",
        focus: "Quads, Hamstrings, Glutes + Abs",
        exercises: [
            { icon: "🏋️", name: "Barbell Back Squat", sets: "4", reps: "6-8", focus: "Quads/Glutes" },
            { icon: "💪", name: "Romanian Deadlifts", sets: "4", reps: "10-12", focus: "Hamstrings" },
            { icon: "🔥", name: "Walking Lunges", sets: "3", reps: "12/leg", focus: "Quads" },
            { icon: "💫", name: "Leg Press", sets: "3", reps: "12-15", focus: "Quads" },
            { icon: "🎯", name: "Toes to Bar", sets: "4", reps: "12-15", focus: "Lower Abs" },
            { icon: "⚡", name: "Russian Twists (weighted)", sets: "4", reps: "20 total", focus: "Obliques" },
            { icon: "🔮", name: "Plank (weighted)", sets: "3", reps: "45-60s", focus: "Core Endurance" }
        ]
    },
    day4: {
        title: "Day 4: Arms + Core Finisher",
        focus: "Biceps, Triceps + Abs",
        exercises: [
            { icon: "🏋️", name: "Close-Grip Bench", sets: "4", reps: "8-10", focus: "Triceps" },
            { icon: "💪", name: "Barbell Curls", sets: "4", reps: "10-12", focus: "Biceps" },
            { icon: "🔥", name: "Skull Crushers", sets: "3", reps: "12-15", focus: "Triceps" },
            { icon: "💫", name: "Hammer Curls", sets: "3", reps: "12-15", focus: "Brachialis" },
            { icon: "🎯", name: "L-Sit Hold", sets: "4", reps: "20-30s", focus: "Hip Flexors/Abs" },
            { icon: "⚡", name: "Bicycle Crunches", sets: "4", reps: "20/side", focus: "Obliques" },
            { icon: "🔮", name: "Hollow Body Hold", sets: "3", reps: "30-45s", focus: "Full Core" }
        ]
    }
};

// BMI Categories
const BMI_CATEGORIES = [
    { max: 18.5, label: "Underweight", color: "#3b82f6" },
    { max: 24.9, label: "Normal", color: "#22c55e" },
    { max: 29.9, label: "Overweight", color: "#f59e0b" },
    { max: 34.9, label: "Obese I", color: "#ef4444" },
    { max: 39.9, label: "Obese II", color: "#dc2626" },
    { max: Infinity, label: "Obese III", color: "#991b1b" }
];

// ==========================================
// DOM ELEMENTS
// ==========================================

const elements = {
    form: document.getElementById('statsForm'),
    resultsSection: document.getElementById('resultsSection'),
    macrosSection: document.getElementById('macrosSection'),
    workoutSection: document.getElementById('workoutSection'),
    progressSection: document.getElementById('progressSection'),
    
    // Results
    bmiValue: document.getElementById('bmiValue'),
    bmiCategory: document.getElementById('bmiCategory'),
    tdeeValue: document.getElementById('tdeeValue'),
    bmrValue: document.getElementById('bmrValue'),
    targetCalories: document.getElementById('targetCalories'),
    calorieGoal: document.getElementById('calorieGoal'),
    
    // Macros
    proteinValue: document.getElementById('proteinValue'),
    carbsValue: document.getElementById('carbsValue'),
    fatsValue: document.getElementById('fatsValue'),
    proteinPercent: document.getElementById('proteinPercent'),
    carbsPercent: document.getElementById('carbsPercent'),
    fatsPercent: document.getElementById('fatsPercent'),
    proteinRing: document.getElementById('proteinRing'),
    carbsRing: document.getElementById('carbsRing'),
    fatsRing: document.getElementById('fatsRing'),
    
    // Workout
    workoutContent: document.getElementById('workoutContent'),
    
    // Progress
    progressChart: document.getElementById('progressChart'),
    progressList: document.getElementById('progressList'),
    saveProgress: document.getElementById('saveProgress')
};

// ==========================================
// CALCULATIONS
// ==========================================

/**
 * Calculate BMI
 * Formula: weight(kg) / height(m)²
 */
function calculateBMI(weight, heightCm) {
    const heightM = heightCm / 100;
    return weight / (heightM * heightM);
}

/**
 * Get BMI Category
 */
function getBMICategory(bmi) {
    for (const category of BMI_CATEGORIES) {
        if (bmi <= category.max) {
            return category;
        }
    }
    return BMI_CATEGORIES[BMI_CATEGORIES.length - 1];
}

/**
 * Calculate BMR using Mifflin-St Jeor Equation (for men)
 * Formula: (10 × weight in kg) + (6.25 × height in cm) − (5 × age in years) + 5
 */
function calculateBMR(weight, heightCm, age) {
    return (10 * weight) + (6.25 * heightCm) - (5 * age) + 5;
}

/**
 * Calculate TDEE
 * Formula: BMR × Activity Multiplier
 */
function calculateTDEE(bmr, activityLevel) {
    return bmr * activityLevel;
}

/**
 * Calculate target calories based on goal
 */
function calculateTargetCalories(tdee, currentWeight, goalWeight) {
    const difference = currentWeight - goalWeight;
    
    if (Math.abs(difference) < 1) {
        // Maintenance
        return { calories: Math.round(tdee), goal: "Maintain", description: "Stay strong, Sensei~!" };
    } else if (difference > 0) {
        // Cutting - 500 cal deficit for ~0.5kg/week loss
        const deficit = Math.min(500, difference * 50); // Scale deficit to difference
        return { 
            calories: Math.round(tdee - deficit), 
            goal: "Cut", 
            description: `${deficit} cal deficit` 
        };
    } else {
        // Bulking - 300-500 cal surplus for lean gains
        const surplus = Math.min(400, Math.abs(difference) * 40);
        return { 
            calories: Math.round(tdee + surplus), 
            goal: "Lean Bulk", 
            description: `${surplus} cal surplus` 
        };
    }
}

/**
 * Calculate macros
 * Protein: 2g per kg bodyweight (for muscle building)
 * Fats: 25% of total calories
 * Carbs: Remainder
 */
function calculateMacros(targetCalories, weight) {
    // Protein: 2g/kg
    const proteinGrams = Math.round(weight * 2);
    const proteinCalories = proteinGrams * 4;
    
    // Fats: 25% of calories
    const fatCalories = targetCalories * 0.25;
    const fatGrams = Math.round(fatCalories / 9);
    
    // Carbs: remaining calories
    const carbCalories = targetCalories - proteinCalories - fatCalories;
    const carbGrams = Math.round(carbCalories / 4);
    
    // Calculate percentages
    const proteinPercent = Math.round((proteinCalories / targetCalories) * 100);
    const fatPercent = 25;
    const carbPercent = 100 - proteinPercent - fatPercent;
    
    return {
        protein: { grams: proteinGrams, percent: proteinPercent },
        carbs: { grams: carbGrams, percent: carbPercent },
        fats: { grams: fatGrams, percent: fatPercent }
    };
}

// ==========================================
// UI UPDATES
// ==========================================

/**
 * Show sections with animation
 */
function showSections() {
    [elements.resultsSection, elements.macrosSection, elements.workoutSection, elements.progressSection].forEach((section, index) => {
        setTimeout(() => {
            section.classList.remove('hidden');
            section.style.animation = 'fadeInUp 0.5s ease-out';
        }, index * 150);
    });
}

/**
 * Update results display
 */
function updateResults(bmi, bmr, tdee, targetData) {
    const category = getBMICategory(bmi);
    
    elements.bmiValue.textContent = bmi.toFixed(1);
    elements.bmiCategory.textContent = category.label;
    elements.bmiCategory.style.color = category.color;
    
    elements.bmrValue.textContent = Math.round(bmr).toLocaleString();
    elements.tdeeValue.textContent = Math.round(tdee).toLocaleString();
    
    elements.targetCalories.textContent = targetData.calories.toLocaleString();
    elements.calorieGoal.textContent = `${targetData.goal} (${targetData.description})`;
}

/**
 * Update macros display with animated rings
 */
function updateMacros(macros) {
    // Update text
    elements.proteinValue.textContent = `${macros.protein.grams}g`;
    elements.carbsValue.textContent = `${macros.carbs.grams}g`;
    elements.fatsValue.textContent = `${macros.fats.grams}g`;
    
    elements.proteinPercent.textContent = `${macros.protein.percent}%`;
    elements.carbsPercent.textContent = `${macros.carbs.percent}%`;
    elements.fatsPercent.textContent = `${macros.fats.percent}%`;
    
    // Animate rings (circumference = 2 * PI * r = 2 * 3.14159 * 40 ≈ 251.2)
    const circumference = 251.2;
    
    setTimeout(() => {
        elements.proteinRing.style.strokeDashoffset = circumference - (circumference * macros.protein.percent / 100);
        elements.carbsRing.style.strokeDashoffset = circumference - (circumference * macros.carbs.percent / 100);
        elements.fatsRing.style.strokeDashoffset = circumference - (circumference * macros.fats.percent / 100);
    }, 300);
}

/**
 * Render workout for selected day
 */
function renderWorkout(day) {
    const workout = WORKOUTS[`day${day}`];
    
    let html = `
        <div class="workout-day-title">${workout.title}</div>
        <p style="color: var(--text-secondary); margin-bottom: var(--space-md); font-size: 0.9rem;">
            Focus: ${workout.focus}
        </p>
        <div class="exercise-list">
    `;
    
    workout.exercises.forEach(exercise => {
        html += `
            <div class="exercise-item">
                <div class="exercise-icon">${exercise.icon}</div>
                <div class="exercise-info">
                    <div class="exercise-name">${exercise.name}</div>
                    <div class="exercise-details">${exercise.sets} sets × ${exercise.reps}</div>
                </div>
                <div class="exercise-focus">${exercise.focus}</div>
            </div>
        `;
    });
    
    html += '</div>';
    elements.workoutContent.innerHTML = html;
}

/**
 * Setup workout tabs
 */
function setupWorkoutTabs() {
    const tabs = document.querySelectorAll('.tab-btn');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            renderWorkout(tab.dataset.day);
        });
    });
    
    // Render day 1 by default
    renderWorkout(1);
}

// ==========================================
// PROGRESS TRACKING
// ==========================================

/**
 * Load progress from localStorage
 */
function loadProgress() {
    const data = localStorage.getItem(PROGRESS_KEY);
    return data ? JSON.parse(data) : [];
}

/**
 * Save progress to localStorage
 */
function saveProgressData(weight) {
    const progress = loadProgress();
    const today = new Date().toISOString().split('T')[0];
    
    // Check if we already have an entry for today
    const existingIndex = progress.findIndex(p => p.date === today);
    
    if (existingIndex >= 0) {
        progress[existingIndex].weight = weight;
    } else {
        progress.push({ date: today, weight: weight });
    }
    
    // Keep only last 30 entries
    if (progress.length > 30) {
        progress.shift();
    }
    
    localStorage.setItem(PROGRESS_KEY, JSON.stringify(progress));
    renderProgress();
}

/**
 * Render progress chart and list
 */
function renderProgress() {
    const progress = loadProgress();
    
    if (progress.length === 0) {
        elements.progressChart.innerHTML = '<div class="progress-empty">No data yet. Save your first entry~!</div>';
        elements.progressList.innerHTML = '<div class="progress-empty">Start tracking to see history!</div>';
        return;
    }
    
    // Find min/max for chart scaling
    const weights = progress.map(p => p.weight);
    const minWeight = Math.min(...weights) - 2;
    const maxWeight = Math.max(...weights) + 2;
    const range = maxWeight - minWeight;
    
    // Render chart bars
    let chartHtml = '';
    progress.slice(-10).forEach(entry => {
        const height = ((entry.weight - minWeight) / range) * 100;
        chartHtml += `<div class="progress-bar" style="height: ${Math.max(10, height)}%" data-weight="${entry.weight}kg"></div>`;
    });
    elements.progressChart.innerHTML = chartHtml;
    
    // Render list (reverse for newest first)
    let listHtml = '';
    [...progress].reverse().slice(0, 10).forEach(entry => {
        const formattedDate = new Date(entry.date).toLocaleDateString('en-US', { 
            month: 'short', 
            day: 'numeric' 
        });
        listHtml += `
            <div class="progress-item">
                <span class="progress-date">${formattedDate}</span>
                <span class="progress-weight">${entry.weight} kg</span>
            </div>
        `;
    });
    elements.progressList.innerHTML = listHtml;
}

/**
 * Save current stats to localStorage
 */
function saveStats(data) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
}

/**
 * Load stats from localStorage
 */
function loadStats() {
    const data = localStorage.getItem(STORAGE_KEY);
    return data ? JSON.parse(data) : null;
}

/**
 * Populate form with saved stats
 */
function populateForm(data) {
    if (!data) return;
    
    document.getElementById('height').value = data.height || '';
    document.getElementById('weight').value = data.weight || '';
    document.getElementById('age').value = data.age || '';
    document.getElementById('goalWeight').value = data.goalWeight || '';
    document.getElementById('activityLevel').value = data.activityLevel || '';
    document.getElementById('bodyType').value = data.bodyType || '';
}

// ==========================================
// EVENT HANDLERS
// ==========================================

/**
 * Handle form submission
 */
function handleSubmit(e) {
    e.preventDefault();
    
    // Get form values
    const height = parseFloat(document.getElementById('height').value);
    const weight = parseFloat(document.getElementById('weight').value);
    const age = parseInt(document.getElementById('age').value);
    const goalWeight = parseFloat(document.getElementById('goalWeight').value);
    const activityLevel = parseFloat(document.getElementById('activityLevel').value);
    const bodyType = document.getElementById('bodyType').value;
    
    // Calculate everything
    const bmi = calculateBMI(weight, height);
    const bmr = calculateBMR(weight, height, age);
    const tdee = calculateTDEE(bmr, activityLevel);
    const targetData = calculateTargetCalories(tdee, weight, goalWeight);
    const macros = calculateMacros(targetData.calories, weight);
    
    // Update UI
    updateResults(bmi, bmr, tdee, targetData);
    updateMacros(macros);
    showSections();
    
    // Save to localStorage
    saveStats({ height, weight, age, goalWeight, activityLevel, bodyType });
    
    // Scroll to results
    setTimeout(() => {
        elements.resultsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }, 200);
}

/**
 * Handle save progress button
 */
function handleSaveProgress() {
    const weight = parseFloat(document.getElementById('weight').value);
    if (weight) {
        saveProgressData(weight);
        
        // Visual feedback
        elements.saveProgress.innerHTML = '<span>Saved! ♡</span>';
        elements.saveProgress.style.background = 'var(--success)';
        
        setTimeout(() => {
            elements.saveProgress.innerHTML = '<span>Save Today\'s Progress</span><span class="btn-icon">💾</span>';
            elements.saveProgress.style.background = '';
        }, 2000);
    }
}

// ==========================================
// INITIALIZATION
// ==========================================

function init() {
    // Load saved data
    const savedStats = loadStats();
    if (savedStats) {
        populateForm(savedStats);
    }
    
    // Setup event listeners
    elements.form.addEventListener('submit', handleSubmit);
    elements.saveProgress.addEventListener('click', handleSaveProgress);
    
    // Setup workout tabs
    setupWorkoutTabs();
    
    // Render initial progress
    renderProgress();
    
    // If we have saved data, trigger calculation
    if (savedStats && savedStats.height && savedStats.weight) {
        handleSubmit(new Event('submit'));
    }
    
    console.log('💪 Sensei\'s Fitness Tracker initialized! Built by MUTSU~♡');
}

// Start the app
document.addEventListener('DOMContentLoaded', init);
