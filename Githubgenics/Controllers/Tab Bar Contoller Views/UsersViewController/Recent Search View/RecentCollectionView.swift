//
//  coll.swift
//  Githubgenics
//
//  Created by Ali Fayed on 30/01/2021.
//

import UIKit
import SafariServices


extension RecentSearchViewController:  UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.lastSearchCell, for: indexPath) as? LastSearchCollectionCell
        cell!.CellData(with: lastSearch[indexPath.row])
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let url = lastSearch[indexPath.row].userURL
        let vc = SFSafariViewController(url: URL(string: url!)!)
        present(vc, animated: true)
        
    }
}