//
//  PickActivityView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 26.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PickActivityView: View {
    @StateObject private var viewModel = PickActivityViewModel.shared
    
    var isFromEditProfile: Bool
    var arrayOfActivity: [UserInterestedCategory]
    
    @State private var subActivityViewPresented = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
            .onAppear { onAppearConfig() }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            header
            
            description
            
            imagesStack
            
            continueButton
        }
    }
    
    private var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_pickActivity,
                   backButtonVisible: false)
    }
    
    private var description: some View {
        VStack(spacing: 16) {
            Text(Constants.label_pickActivityScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_pickActivityScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, 40)
        .padding(.horizontal)
    }
    
    private var imagesStack: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach($viewModel.arrayOfActivity) { activity in
                    if let image = activity.image.wrappedValue, let imageURL = URL(string: UrlActivityImage + image) {
                        imageCell(activity.wrappedValue, imageURL: imageURL)
                            .frame(maxHeight: 210)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    private func imageCell(_ activity: ActivityCategoryClass, imageURL: URL) -> some View {
        ZStack {
            WebImage(url: imageURL)
                .placeholder {
                    Image("placeholder_activity")
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 210)
                }
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 210)
            
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
    
    private var continueButton: some View {
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
        .padding(.bottom, 30)
        .padding(.top, 16)
    }
    
    private var presentables: some View {
        ZStack {
            NavigationLink(destination: PickSubActivityView(isFromEditProfile: isFromEditProfile,
                                                            categoryIds: isFromEditProfile ? viewModel.getSelectedCategoryId().map({String($0)}).joined(separator: ", ") : viewModel.getSelectedCategoryId().map({String($0)}).joined(separator: ", ")),
                           isActive: $subActivityViewPresented,
                           label: EmptyView.init)
            .isDetailLink(false)
        }
    }
    
    private func onAppearConfig() {
        viewModel.callGetActivityDataAPI()
        
        if isFromEditProfile {
            setupSelectedActivity()
        }
    }
    
    private func continueAction() {
        if viewModel.getSelectedCategoryId().count >= 3 {
            if isFromEditProfile {
                //Remove deleted activity from the edit array
                let deletedIds = viewModel.getDeletedActivityIds()
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
                
                subActivityViewPresented.toggle()
            } else {
                subActivityViewPresented.toggle()
            }
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_pickActivity)
        }
    }
    
    func setupSelectedActivity() {
        viewModel.removeAllSelectedArray()
        
        for activityData in arrayOfActivity {
            if viewModel.getSelectedCategoryId().contains(where: {$0 == activityData.activityId}) == false {
                viewModel.setSelectedCategoryId(value: activityData.activityId ?? 0)
            }
        }
    }
    
    private func cellTap(for activity: ActivityCategoryClass) {
        if viewModel.getSelectedCategoryId().contains(where: {$0 == activity.id}) {
            if let index = viewModel.getSelectedCategoryId().firstIndex(where: {$0 == activity.id}) {
                viewModel.removeSelectedCategoryId(at: index)
                if isFromEditProfile {
                    if viewModel.getAllSelectedActivity().contains(where: {$0.activityCategoryId == "\(activity.id ?? 0)"}) == true {
                        viewModel.setDeletedActivityIds(value: activity.id ?? 0)
                    }
                }
            }
        } else {
            viewModel.setSelectedCategoryId(value: activity.id ?? 0)
            if let index = viewModel.getDeletedActivityIds().firstIndex(where: {$0 == activity.id ?? 0}) {
                viewModel.removeDeletedActivityIds(at: index)
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
        PickActivityView(isFromEditProfile: false, arrayOfActivity: [])
    }
}
