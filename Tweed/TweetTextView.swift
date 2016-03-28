//
//  TweetTextView.swift
//  Sesh
//
//  Created by Zachary Saraf on 3/27/16.
//  Copyright © 2016 Zachary Waleed Saraf. All rights reserved.
//

import UIKit

protocol TweetTextViewDelegate: class {
    func tweetTextViewDidTapUrl(textView: TweetTextView, url: String)
    func tweetTextViewDidTapMedia(textView: TweetTextView, media: Media)
    func tweetTextViewDidTapMention(textView: TweetTextView, mention: Mention)
}

struct TweetTextViewConstants {
    static let LeftInset = 5.0
}

class TweetTextView: UITextView, UIGestureRecognizerDelegate {

    enum TweetEmbeddedType {
        case Mention, Url, Media;
    }

    static let TypeIdentifier = "type"
    static let IdIdentifier = "id"
    static let UrlIdentifier = "url"
    static let MediaIdentifier = "media"

    var tapRecognizer: UITapGestureRecognizer!
    weak var tweetDelegate: TweetTextViewDelegate?

    var tweet: Tweet? {
        didSet {
            if self.tweet != nil {
                let regularFont = UIFont.SFRegular(15.0)
                let mediumFont = UIFont.SFMedium(15.0)
                let textColor = UIColor.tweedGray()
                let attributedText = NSMutableAttributedString(string: self.tweet!.text!, attributes: [NSFontAttributeName: regularFont!, NSForegroundColorAttributeName: textColor])

                for obj in tweet!.mentions! {
                    let mention = (obj as! Mention)
                    let range = (attributedText.string as NSString).rangeOfString("@\(mention.screenName!)")
                    attributedText.addAttributes([TweetTextView.IdIdentifier: mention.id!, TweetTextView.TypeIdentifier: TweetEmbeddedType.Mention.hashValue, NSForegroundColorAttributeName: UIColor.tweedBlue(), NSFontAttributeName: mediumFont!], range: range)
                }

                for obj in tweet!.urls! {
                    let url = (obj as! Url)
                    let range = (attributedText.string as NSString).rangeOfString(url.fakeUrl!)
                    attributedText.addAttributes([TweetTextView.UrlIdentifier: url.realUrl!, TweetTextView.TypeIdentifier: TweetEmbeddedType.Url.hashValue, NSForegroundColorAttributeName: UIColor.tweedBlue(), NSFontAttributeName: mediumFont!], range: range)
                }

                for obj in tweet!.media! {
                    let media = obj as! Media
                    let startIdx = media.startIdx as! Int
                    let endIdx = media.endIdx as! Int
                    let range = NSMakeRange(startIdx, endIdx - startIdx)
                    attributedText.addAttributes([TweetTextView.IdIdentifier: media.id!, TweetTextView.TypeIdentifier: TweetEmbeddedType.Media.hashValue, NSForegroundColorAttributeName: UIColor.tweedBlue(), NSFontAttributeName: mediumFont!], range: range)
                }

                self.attributedText = attributedText
            }

            self.tapRecognizer.enabled = self.tweet != nil
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: CGRectZero, textContainer: textContainer)

        self.editable = false
        self.scrollEnabled = false
        self.contentInset = UIEdgeInsetsZero
        self.textContainer.lineFragmentPadding = 0.0
        self.textContainerInset = UIEdgeInsetsMake(0, CGFloat(TweetTextViewConstants.LeftInset), 0, 0)
        self.textContainer.lineBreakMode = NSLineBreakMode.ByWordWrapping

        for recognizer in self.gestureRecognizers! {
            recognizer.enabled = false
        }

        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        self.tapRecognizer.delegate = self
        self.addGestureRecognizer(self.tapRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(self)

        let idx = self.characterIdxForLocation(location)
        if idx != nil {
            var range : NSRange? = NSMakeRange(0, 1)
            let value = self.attributedText.attribute(TweetTextView.TypeIdentifier, atIndex: idx!, effectiveRange: &range!) as? Int
            if (value != nil && self.tweet != nil) {
                if value == TweetEmbeddedType.Url.hashValue {
                    let url = self.attributedText.attribute(TweetTextView.UrlIdentifier, atIndex: idx!, effectiveRange: &range!) as? String
                    if url != nil {
                        self.tweetDelegate?.tweetTextViewDidTapUrl(self, url: url!)
                    }
                } else if value == TweetEmbeddedType.Mention.hashValue {
                    let id = self.attributedText.attribute(TweetTextView.IdIdentifier, atIndex: idx!, effectiveRange: &range!) as? Int
                    if id != nil {
                        let mention = tweet?.mentions?.filter({ (obj: AnyObject) -> Bool in
                            return ((obj as! Mention).id as! Int) == id
                        }).first as! Mention
                        self.tweetDelegate?.tweetTextViewDidTapMention(self, mention: mention)
                    }
                } else {
                    let id = self.attributedText.attribute(TweetTextView.IdIdentifier, atIndex: idx!, effectiveRange: &range!) as? Int
                    if id != nil {
                        let media = tweet?.media?.filter({ (obj: AnyObject) -> Bool in
                            return ((obj as! Media).id as! Int) == id
                        }).first as! Media
                        self.tweetDelegate?.tweetTextViewDidTapMedia(self, media: media)
                    }
                }
            }
        }
    }

    func characterIdxForLocation(var point: CGPoint) -> Int? {
        point.x -= self.textContainerInset.left
        point.y -= self.textContainerInset.top

        let characterIndex = self.layoutManager.characterIndexForPoint(point, inTextContainer: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < self.textStorage.length {
            return characterIndex
        }

        return nil
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let idx = self.characterIdxForLocation(point)
        if idx != nil {
            var range : NSRange? = NSMakeRange(0, 1)
            let value = self.attributedText.attribute(TweetTextView.TypeIdentifier, atIndex: idx!, effectiveRange: &range!) as? Int
            if (value != nil && self.tweet != nil) {
                return super.hitTest(point, withEvent: event)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }


}
