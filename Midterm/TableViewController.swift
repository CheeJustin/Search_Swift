//
//  TableViewController.swift
//  Midterm
//
//  Created by Justin Chee on 2015-02-17.
//  Copyright (c) 2015 Justin Chee. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate
{
    
    let cellID = "ID"
    var games = [Game]()
    var filteredGames = [Game]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.games = [
            Game(title: "Resident Evil", genre: ["Survival Horror", "Third-Person Shooter"], year: 1996),
            Game(title: "The Legend of Zelda: Ocarina of Time", genre: ["Action-Advaneture"], year: 1998),
            Game(title: "Silent Hill", genre: ["Survival Horror"], year: 1999),
            Game(title: "The Legend of Zelda: Majora's Mask", genre: ["Action-Adventure"], year: 2000),
            Game(title: "Silent Hill 2", genre: ["Survival Horror"], year: 2001),
            Game(title: "Silent Hill 3", genre: ["Survival Horror"], year: 2003),
            Game(title: "Rule of Rose", genre: ["Survival Horror"], year: 2006),
            Game(title: "Portal", genre: ["Puzzle-Platformer"], year: 2007),
            Game(title: "Dead Space", genre: ["Survival Horror"], year: 2008),
            Game(title: "Dead Space 2", genre: ["Survival Horror"], year: 2011),
            Game(title: "Hatoful Boyfriend", genre: ["Visual Novel", "Dating Simulation", "Otome Game", "Nakige"], year: 2011),
            Game(title: "How to Survive", genre: ["Survival Horror", "Action Role-Playing"], year: 2013)
                    ]
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            return self.filteredGames.count
        }
        else
        {
            return self.games.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell
        
        var game: Game
        
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            game = filteredGames[indexPath.row]
        }
        else
        {
            game = games[indexPath.row]
        }
        
        var text = String(game.year) + "\n" + game.genre[0]
        for var i = 1; i < game.genre.count; i++
        {
            text += ", " + game.genre[i]
        }
        
        cell.textLabel?.text = game.title
        cell.detailTextLabel?.text = text
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("goToDetail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "goToDetail"
        {
            let detailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView
            {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                detailViewController.title = self.filteredGames[indexPath.row].title
            }
            else
            {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                detailViewController.title = self.games[indexPath.row].title
            }
        }
    }
    
    // Start of search functions
    func filterContent(searchText: String, scope: String = "All")
    {
        self.filteredGames = self.games.filter({(game: Game) -> Bool in
            
            let titleMatch = game.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let genre = " ".join(game.genre)
            let genreMatch = genre.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let yearMatch = String(game.year).rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            switch scope
            {
                case "Title":
                    return (titleMatch != nil)
                case "Genre":
                    return (genreMatch != nil)
                case "Year":
                    return (yearMatch != nil)
                default:
                    return (titleMatch != nil) || (genreMatch != nil) || (yearMatch != nil)
            }
        })
    }
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        let scopes = self.searchDisplayController?.searchBar.scopeButtonTitles as [String]
        let index = self.searchDisplayController?.searchBar.selectedScopeButtonIndex as Int!
        let selectedScope = scopes[index]
        self.filterContent(searchString, scope: selectedScope)
        
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        let scope = self.searchDisplayController?.searchBar.scopeButtonTitles as [String]
        self.filterContent(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        return true
    }
    
    // Although the functionality of code within this function is not ideal when using a searchbar, this is used to demonstrate the possibilities. As such, this can be expanded to create an autocomplete view of some sort, by saving the search term and reusing it when the user is typing
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar)
    {
        var date = NSDate()
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitYear, fromDate: date)
        
        self.games.append(Game(title: searchBar.text, genre: ["Custom"], year: components.year))
        println("Save search: " + searchBar.text);
        
        // Instantly reload search terms by indirectly calling shouldReloadTableForSearchString
        searchBar.text = "" + searchBar.text
    }
}
