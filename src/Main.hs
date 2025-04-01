module Main where
import System.Environment (getArgs)
import Text.Read (readMaybe)
import Control.Exception (catch, SomeException)
import System.IO (hPutStrLn, stderr)
import System.Process (readProcess)

-- Evaluate a function dynamically using GHCi
evaluateFunction :: String -> Double -> IO ()
evaluateFunction funcStr x = catch (do
    let expr = "let x = " ++ show x ++ " in " ++ funcStr
    result <- readProcess "ghci" ["-e", expr] ""
    putStrLn ("Resultado: " ++ result)
  ) handleError
  where
    handleError :: SomeException -> IO ()
    handleError e = hPutStrLn stderr ("Erro ao avaliar: " ++ show e)

main :: IO ()
main = do
    args <- getArgs
    case args of
        [funcStr, numStr] -> case readMaybe numStr of
            Just x -> evaluateFunction funcStr x
            Nothing -> putStrLn "Entrada inválida"
        _ -> putStrLn "Uso: runhaskell Main.hs <funcao> <numero>"
