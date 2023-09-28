//
//  PickActivityView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 26.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PickActivityView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject private var viewModel = PickActivityViewModel()
    
    var isFromEditProfile: Bool
    var arrayOfActivity: [UserInterestedCategory]
    
    @Binding var activitiesFlowPresented: Bool
    
    @State private var arrayOfSubActivity: [UserInterestedCategory] = []
    @State private var subActivityViewPresented = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .onAppear { onAppearConfig() }
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                description
                
                imagesStack
            }
            
            continueButton
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_pickActivity,
                       backButtonVisible: isFromEditProfile,
                       backAction: { presentationMode.wrappedValue.dismiss() })
            
            if !isFromEditProfile {
                OnboardingProgressView(totalSteps: 9, currentStep: 5)
            }
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_pickActivityScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_pickActivityScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.vertical)
        .padding(.horizontal)
    }
    
    private var imagesStack: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach($viewModel.arrayOfActivity) { activity in
                    imageCell(activity.wrappedValue)
                        .frame(maxHeight: 210)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
    }
    
    private func imageCell(_ activity: ActivityCategoryClass) -> some View {
        ZStack {
            let cellWidth = (screenSize.width - 40) / 2
            let cellHeight = cellWidth + (cellWidth * 0.2)
            
            WebImage(url: viewModel.imageURL(for: activity, imageSize: CGSize(width: cellWidth, height: cellHeight)))
                .placeholder {
                    Image("placeholder_activity")
                        .resizable()
                        .scaledToFill()
                        .frame(width: cellWidth, height: cellHeight)
                }
                .resizable()
                .scaledToFill()
                .frame(width: cellWidth, height: cellHeight)
            
            gradient
            
            VStack {
                Spacer()
                
                HStack {
                    Text(activity.title ?? "")
                        .font(.themeMedium(14))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .padding(16)
            
            Color.black
                .opacity(activityIsSelected(activity) ? 0.6 : 0)
                .animation(.default, value: viewModel.arrayOfSelectedCategoryIds.count)
            
            Image("ic_category_selectiontick")
                .opacity(activityIsSelected(activity) ? 1 : 0)
                .animation(.default, value: viewModel.arrayOfSelectedCategoryIds.count)
        }
        .onTapGesture {
            cellTap(for: activity)
        }
    }
    
    private var gradient: some View {
        VStack {
            Spacer()
            
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .allowsHitTesting(false)
                .frame(height: 100)
        }
    }
    
    private var continueButton: some View {
        VStack {
            Spacer()
            
            Button(action: { continueAction() }) {
                ZStack {
                    Color.theme
                    
                    Text(Constants.btn_continue)
                        .font(.themeBold(20))
                        .foregroundColor(.colorWhite)
                }
            }
            .frame(height: 60)
            .cornerRadius(30)
            .padding(.horizontal, 30)
            .padding(.bottom, safeAreaInsets.bottom == 0 ? 16 : safeAreaInsets.bottom)
            .padding(.top, 16)
        }
    }
    
    private var presentables: some View {
        NavigationLink(destination: PickSubActivityView(isFromEditProfile: isFromEditProfile,
                                                        categoryIds: isFromEditProfile ? viewModel.arrayOfSelectedCategoryIds.map({String($0)}).joined(separator: ", ") : viewModel.arrayOfSelectedCategoryIds.map({String($0)}).joined(separator: ", "),
                                                        arrayOfSubActivity: arrayOfSubActivity,
                                                        activitiesFlowPresented: $activitiesFlowPresented),
                       isActive: $subActivityViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func onAppearConfig() {
        viewModel.callGetActivityDataAPI()
        
        if isFromEditProfile {
            setupSelectedActivity()
        }
    }
    
    private func continueAction() {
        if viewModel.arrayOfSelectedCategoryIds.count >= 3 {
            if isFromEditProfile {
                //Remove deleted activity from the edit array
                let deletedIds = viewModel.arrayOfDeletedActivityIds
                var arrFilteredIds = arrayOfActivity
                
                for i in 0..<deletedIds.count {
                    let arr1 = arrFilteredIds.filter({$0.activityId == deletedIds[i]})
                    
                    if arr1.count > 0 {
                        
                        let sub_cat_array = arr1.map({$0.subActivityId})
                        
                        for j in 0..<arr1.count {
                            if let index = arrFilteredIds.firstIndex(where: {$0.activityId == deletedIds[i] && $0.subActivityId == sub_cat_array[j]}) {
                                arrFilteredIds.remove(at: index)
                            }
                        }
                    }
                }
                
                arrayOfSubActivity = arrFilteredIds
                
                subActivityViewPresented.toggle()
            } else {
                subActivityViewPresented.toggle()
            }
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_pickActivity)
        }
    }
    
    func setupSelectedActivity() {
        viewModel.arrayOfSelectedPickActivity.removeAll()
        
        for activityData in arrayOfActivity {
            if viewModel.arrayOfSelectedCategoryIds.contains(where: {$0 == activityData.activityId}) == false {
                viewModel.arrayOfSelectedCategoryIds.append(activityData.activityId ?? 0)
            }
        }
    }
    
    private func cellTap(for activity: ActivityCategoryClass) {
        if viewModel.arrayOfSelectedCategoryIds.contains(where: { $0 == activity.id }) {
            if let index = viewModel.arrayOfSelectedCategoryIds.firstIndex(where: { $0 == activity.id }) {
                viewModel.arrayOfSelectedCategoryIds.remove(at: index)
                if isFromEditProfile {
                    if viewModel.arrayOfAllSelectedActivity.contains(where: { $0.activityCategoryId == "\(activity.id ?? 0)" }) == true {
                        viewModel.arrayOfDeletedActivityIds.append(activity.id ?? 0)
                    }
                }
            }
        } else {
            viewModel.arrayOfSelectedCategoryIds.append(activity.id ?? 0)
            if let index = viewModel.arrayOfDeletedActivityIds.firstIndex(where: {$0 == activity.id ?? 0}) {
                viewModel.arrayOfDeletedActivityIds.remove(at: index)
            }
        }
    }
    
    private func activityIsSelected(_ activity: ActivityCategoryClass) -> Bool {
        guard let activityID = activity.id else { return false }
        print(viewModel.arrayOfSelectedCategoryIds)
        return viewModel.arrayOfSelectedCategoryIds.contains(activityID)
    }
}

struct PickActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PickActivityView(isFromEditProfile: false, arrayOfActivity: [], activitiesFlowPresented: .constant(true))
    }
}
